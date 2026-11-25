---
name: luci-luci-preflight-pdf
description: Fecha e confere a entrega final de uma APN Luci Luci a partir do PSD ou PSB editável. Usar ao solicitar PDF final, prova de leitura, revisão de páginas ou checagem de links.
---

# Fechamento do PDF

1. Identificar o mestre e o destino. Para revisão no Photoshop, trabalhar no PSD. Quando for solicitada a entrega, exportar a partir de uma cópia temporária do mestre. Preservar a visibilidade das camadas internas, inclusive exclusões manuais como a pipeta da escala de pH.
2. Para grupos numerados, ordenar pelo número editorial. Na cópia, exibir somente a página atual e os elementos globais previstos. Em pranchetas, confirmar a caixa de cada uma. Exportar com as dimensões e o perfil colorimétrico definidos para o destino. Para projeção, conservar texto legível e proporção 16:9 quando essa for a proporção do mestre.
3. Montar com Apresentação de PDF do Photoshop ou com uma ferramenta PDF disponível. Quando a entrega prevê pesquisa ou links, preservar texto selecionável e inserir links na área real do periódico. Em páginas rasterizadas conferir busca, acentos e alinhamento da camada de texto com a imagem final. Conferir as referências contra a edição aprovada.
4. Abrir o PDF final e verificar a quantidade, ordem, capa, páginas densas e encerramento. Inspecionar fotos, tipo miúdo, margens, marca corporativa, marca do produto e variações claro/escuro. Testar cada link. Entregar o mestre editável e o PDF identificado pela mesma revisão. Salvar provas parciais com nome que explicite o estágio.

## Verificação estrutural opcional no PowerShell

Com Python e PyMuPDF disponíveis (`python -m pip install PyMuPDF`), execute na pasta desta skill. Ajuste o número de páginas, os termos e as referências ao briefing real.

~~~powershell
python .\scripts\conferir_pdf.py '.\treinamento.pdf' --paginas 10 --formato-16x9 --termo '10 minutos' --links-minimos 3
~~~

O script indica divergência pelo código de saída e informa dimensões, quantidade de caracteres e links externos por página. Na revisão visual, conferir também se o link cobre a referência correta e se o texto buscável coincide com a arte final.
