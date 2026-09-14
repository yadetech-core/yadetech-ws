#!/usr/bin/env bash
# Confere o SEO do site publicado percorrendo o sitemap. Só lê (curl).
#
#   bash scripts/seo-no-ar.sh https://www.dominio.com.br [host-alternativo]
#
# O host alternativo padrão é a versão com ou sem www do principal. Passe outro
# no segundo argumento, ou "-" para pular (subdomínio, *.vercel.app).
#
# Para cada URL do sitemap: status (tem de ser 200), canonical igual à própria
# URL, og:image e twitter:image presentes, um h1 e a meta robots. Depois: host
# alternativo redirecionando, robots.txt, 404 de verdade e JSON-LD da home.
set -uo pipefail
D="${1:?informe a URL principal, ex.: https://www.dominio.com.br}"
D="${D%/}"
erros=0
marca() { erros=$((erros + 1)); printf '  !! %s\n' "$1"; }

echo "== Host alternativo"
ALT="${2:-}"
if [ -z "$ALT" ]; then
  if [[ "$D" == *".vercel.app"* ]]; then ALT="-"
  elif [[ "$D" == *"://www."* ]]; then ALT="${D/:\/\/www./://}"
  else ALT="${D/:\/\//://www.}"; fi
fi
if [ "$ALT" = "-" ]; then
  echo "  (pulado)"
else
  loc=$(curl -sI "$ALT" | awk 'tolower($1)=="location:"{print $2}' | tr -d '\r')
  echo "  $ALT -> ${loc:-(sem redirect)}"
  [[ "${loc%/}" == "$D"* ]] || marca "o host alternativo não redireciona para $D (se não se aplica, passe - no 2º argumento)"
fi

echo "== robots.txt"
robots=$(curl -s "$D/robots.txt")
echo "$robots" | sed 's/^/  /'
echo "$robots" | grep -qi "sitemap: $D/sitemap.xml" || marca "robots.txt não aponta para $D/sitemap.xml"

echo "== URLs do sitemap"
urls=$(curl -s "$D/sitemap.xml" | grep -oE '<loc>[^<]+' | sed 's/<loc>//')
[ -n "$urls" ] || marca "sitemap vazio ou inacessível"
for u in $urls; do
  status=$(curl -s -o /dev/null -w '%{http_code}' "$u")
  if [ "$status" != 200 ]; then
    marca "$status $u (sitemap só com URL que responde 200; confira SITE.url)"
    continue
  fi
  h=$(curl -s "$u")
  canon=$(echo "$h" | grep -oE '<link rel="canonical" href="[^"]+"' | head -1 | cut -d'"' -f4)
  og=$(echo "$h" | grep -c 'property="og:image"')
  tw=$(echo "$h" | grep -c 'name="twitter:image"')
  h1=$(echo "$h" | grep -o '<h1[ >]' | wc -l | tr -d ' ')
  robots_meta=$(echo "$h" | grep -oE '<meta name="robots" content="[^"]+"' | head -1 | cut -d'"' -f4)
  titulo=$(echo "$h" | grep -oE '<title>[^<]*' | head -1 | sed 's/<title>//')
  printf '%s %s\n     title(%s)="%s" canon=%s og=%s tw=%s h1=%s robots=%s\n' \
    "$status" "$u" "${#titulo}" "$titulo" "${canon:-—}" "$og" "$tw" "$h1" "${robots_meta:-—}"
  [ "${canon%/}" = "${u%/}" ] || marca "$u com canonical diferente: ${canon:-ausente}"
  [ "$og" -ge 1 ] || marca "$u sem og:image"
  [ "$tw" -ge 1 ] || marca "$u sem twitter:image"
  [ "$h1" = 1 ] || marca "$u com $h1 h1"
  [[ "$robots_meta" == *noindex* ]] && marca "$u está no sitemap com noindex"
done

echo "== 404"
c=$(curl -s -o /dev/null -w '%{http_code}' "$D/pagina-que-nao-existe-$RANDOM")
echo "  $c"
[ "$c" = 404 ] || marca "rota inexistente responde $c"

echo "== JSON-LD da home"
curl -s "$D/" | grep -oE '"@type":"[A-Za-z]+"' | sort | uniq -c | sed 's/^/  /'

echo
[ "$erros" -eq 0 ] && echo "Sem problemas encontrados." || echo "$erros problema(s) marcados com !!"
echo "Falta à mão: Rich Results Test, Lighthouse mobile nas páginas de entrada, Search Console."
