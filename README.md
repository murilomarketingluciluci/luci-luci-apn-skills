# APNs de produto da Luci Luci

Três skills para criar treinamentos multipágina com a identidade da Luci Luci e a direção de arte de cada produto. O principal exemplo é o PSD do Vitae Water Alcaline, com os ajustes manuais de tipografia, grupos, máscaras e Desfoque de campo. Os editáveis e os PDFs de outras linhas estão no acervo.

## Instalar pelo PowerShell

Com Node.js, npm e Git disponíveis, abra o PowerShell na pasta do projeto e execute:

~~~powershell
npx.cmd --yes skills@1.9.0 add murilomarketingluciluci/luci-luci-apn-skills --agent codex --skill "*" --copy -y
~~~

A instalação padrão acima vale para esse projeto. Para disponibilizar as skills nos projetos do usuário, acrescente `--global` ao comando. Para listar antes de instalar, use:

~~~powershell
npx.cmd --yes skills@1.9.0 add murilomarketingluciluci/luci-luci-apn-skills --list
~~~

A CLI instala as instruções e os recursos leves. Para editar o PSD ao vivo pelo COM, use Windows com Adobe Photoshop instalado e disponível. Para reproduzir a tipografia da marca, disponibilize a família Gotham no Photoshop. Para gerar cenas inéditas, use o gerador de imagens disponível no seu ambiente.

## Qual skill usar

| Skill | Quando usar | Resultado |
|---|---|---|
| [luci-luci-pdfs-photoshop](skills/luci-luci-pdfs-photoshop/SKILL.md) | Briefing, copy, direção visual, criação de páginas, revisões no mestre e organização de camadas | APN editável no Photoshop com grid, hierarquia, máscaras e identidade da linha |
| [luci-luci-fotografia-de-produto](skills/luci-luci-fotografia-de-produto/SKILL.md) | Falta uma fotografia, um macro, uma cena de uso ou um mockup fiel | Prompt completo por tomada, referências com função definida e conferência física da imagem |
| [luci-luci-preflight-pdf](skills/luci-luci-preflight-pdf/SKILL.md) | Pedido de prova ou fechamento do PDF | Sequência revisada, links do estudo, texto e formato conferidos contra o mestre |

Para pedir outra APN: “Use a skill luci-luci-pdfs-photoshop para montar o treinamento de [produto e variante]. A copy aprovada é [arquivo]. A referência da linha é [PDF/PSD]. As fotos oficiais de geometria, rótulo e escala são [arquivos]. Quero [formato e finalidade]. Trabalhe no PSD e deixe a página aberta nas revisões.”

**A foto nova nasce com o produto dentro da cena.** Use a embalagem oficial para definir forma, rótulo e escala. Peça a tomada inteira em um prompt e confira reflexos, transparências, contato, mãos e detalhes impressos. Se o produto parecer um PNG colado ao cenário, a foto precisa ser refeita a partir das referências originais.

## Baixar os PSDs, PSB, PDFs e fotos

Consulte o [catálogo com correspondência entre edições](ACERVO.md). Para baixar somente o mestre Alcaline e o teste de vidro:

~~~powershell
git clone https://github.com/murilomarketingluciluci/luci-luci-apn-skills.git
Set-Location luci-luci-apn-skills
.\scripts\baixar-acervo.ps1 -Arquivo 'alcaline-mestre.psd','estudo-vidro.psd'
~~~

Para obter todos os arquivos, execute `.\scripts\baixar-acervo.ps1` dentro do clone. O script confere tamanho e SHA-256 e aproveita os arquivos já íntegros. Também é possível baixar cada item diretamente na [release do acervo](https://github.com/murilomarketingluciluci/luci-luci-apn-skills/releases/tag/v1.0.0). O arquivo `alcaline-prova-anterior.pdf` documenta uma etapa intermediária; o mestre PSD registra os ajustes mais recentes.

## Recursos reutilizáveis

- [Guia de produção por tipo de página](skills/luci-luci-pdfs-photoshop/references/producao-apn.md) e [composição, grids e máscaras](skills/luci-luci-pdfs-photoshop/references/composicao.md).
- [Desfoque de campo por pinos](skills/luci-luci-pdfs-photoshop/references/desfoque-de-campo.md) e [função JSX para Photoshop](skills/luci-luci-pdfs-photoshop/scripts/desfoque-de-campo.jsx). A função recebe X, Y e raio no documento atual e atua no objeto inteligente ativo.
- [Ícones e setas vetoriais](skills/luci-luci-pdfs-photoshop/assets/icones) para os casos do Alcaline. Adaptar o símbolo, a cor e a legenda à grandeza ou material da nova página.
- [Direção fotográfica por linha](skills/luci-luci-fotografia-de-produto/references/direcao.md), com critérios para aprovar uma cena ou refazê-la.

O código e as instruções deste repositório podem ser usados e adaptados sob a [licença MIT](LICENSE). Marcas, fotografias, artes de produto e materiais de referência conservam seus direitos próprios. A fonte Gotham é obtida separadamente.

## Ferramentas de apoio durante a produção

| Momento | Recurso do ambiente | Como entra no fluxo |
|---|---|---|
| Encontrar uma edição de referência | Acervo local e, quando disponível, integração do Google Drive | Começar pelo catálogo, comparar número e ordem das páginas e confirmar se o editável corresponde à edição. Os arquivos da release permitem consulta local. |
| Produzir uma tomada inédita | Gerador de imagens com entrada por referência, como ImageGen | A skill de fotografia define papéis das imagens, prompt integral, critérios de reprovação e revisão com os originais. |
| Montar e revisar | Adobe Photoshop, COM no Windows, SVG como objeto inteligente | Trabalhar com grupos de página, tipografia nativa, máscaras por material e filtros editáveis. A função de campo e o [comando PowerShell](skills/luci-luci-pdfs-photoshop/scripts/aplicar-desfoque.ps1) acompanham a skill principal. |
| Fechar o arquivo de leitura | Ferramenta de PDF do ambiente ou Photoshop e biblioteca de PDF | A skill de fechamento define como conferir ordem, dimensões, texto pesquisável e referências clicáveis quando pedidos. |
| Incorporar novo aprendizado | Skill Creator quando disponível ou edição do SKILL.md e das referências | Registrar a mudança que o designer aprovou, distinguir regra de marca de escolha daquela linha e testar num caso diferente antes de publicar a próxima revisão. |
