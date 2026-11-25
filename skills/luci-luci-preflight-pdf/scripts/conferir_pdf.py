"""Conferência estrutural de uma entrega. Requer PyMuPDF."""
import argparse
from pathlib import Path
import sys

import pymupdf


def verificar(arquivo, paginas, proporcao, termos, links_minimos):
    falhas = []
    textos = []
    links = 0
    with pymupdf.open(arquivo) as pdf:
        if pdf.page_count == 0:
            falhas.append("PDF vazio")
        if paginas is not None and pdf.page_count != paginas:
            falhas.append(f"Esperadas {paginas} páginas, encontradas {pdf.page_count}")
        for pagina in pdf:
            numero = pagina.number + 1
            retangulo = pagina.rect
            if proporcao and abs(retangulo.width / retangulo.height - proporcao) > 0.01:
                falhas.append(f"Página {numero}: proporção divergente")
            quantidade = sum(bool(link.get("uri")) for link in pagina.get_links())
            links += quantidade
            texto = pagina.get_text()
            textos.append(" ".join(texto.casefold().split()))
            print(f"Página {numero:02d} | {retangulo.width:g} × {retangulo.height:g} pt | "
                  f"{len(texto.strip())} caracteres | {quantidade} links externos")
        if links < links_minimos:
            falhas.append(f"Esperados pelo menos {links_minimos} links, encontrados {links}")
    for termo in termos:
        if not any(" ".join(termo.casefold().split()) in texto for texto in textos):
            falhas.append(f"Termo ausente na camada de leitura: {termo}")
    return falhas


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("arquivo", type=Path)
    parser.add_argument("--paginas", type=int)
    parser.add_argument("--formato-16x9", action="store_true")
    parser.add_argument("--termo", action="append", default=[])
    parser.add_argument("--links-minimos", type=int, default=0)
    args = parser.parse_args()
    falhas = verificar(args.arquivo, args.paginas, 16 / 9 if args.formato_16x9 else None,
                       args.termo, args.links_minimos)
    for mensagem in falhas:
        print(mensagem, file=sys.stderr)
    return int(bool(falhas))


if __name__ == "__main__":
    raise SystemExit(main())
