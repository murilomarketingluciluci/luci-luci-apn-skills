# Desfoque de campo na tipografia

Usar em palavras-chave integradas à foto. Escolher escala e repetição conforme o espaço da cena: uma palavra pode aparecer menor e repetida em linhas. O foco varia pela posição na imagem, inclusive dentro da mesma letra. Manter as instruções de leitura em texto nítido.

## Compor os planos

1. Localizar três regiões na foto: trecho da palavra livre sobre o fundo, entrada na silhueta e trecho visto através do vidro. Posicionar os pinos sobre letras visíveis. No metal opaco, quem produz a oclusão é a máscara do produto.
2. Manter a foto no fundo e o recorte com máscara acima da tipografia. Converter a camada de texto em objeto inteligente antes de aplicar o filtro. Quando as repetições formarem uma composição única, reunir os textos editáveis em um objeto inteligente.
3. Aplicar **Galeria de desfoques → Desfoque de campo** nesse objeto. No teste aprovado de “Como usar”, a leitura começa nítida do lado do sofá, perde foco na entrada do vidro e fica mais difusa atrás da garrafa. Na serigrafia e no bastão, preservar os detalhes da foto em primeiro plano.

| Pino no teste de 1080 × 1350 px | X | Y | Raio |
|---|---:|---:|---:|
| Palavra livre, sobre o sofá | 102 | 810 | 0 px |
| Transição para o vidro | 345 | 733 | 4 px |
| Palavra atrás da garrafa | 505 | 701 | 12 px |

As coordenadas são em pixels a partir do canto superior esquerdo do documento. Em outra imagem, localizar novamente as três regiões. Se a garrafa estiver à esquerda, o sentido do foco acompanha a garrafa. Calibrar o raio pela espessura da letra no tamanho final.

## Controlar os pinos pelo COM do Photoshop

Via DoJavaScript ou DoJavaScriptFile, ativar o documento e a camada pretendidos. Converter o texto com o evento newPlacedLayer quando necessário. Usar o descritor abaixo no objeto inteligente ativo. A lista recebe trios de coordenada X, coordenada Y e raio em pixels. Este exemplo aplica o filtro sem abrir a galeria.

~~~javascript
function aplicarDesfoqueDeCampo(pinos) {
    var doc = app.activeDocument;
    if (doc.activeLayer.kind !== LayerKind.SMARTOBJECT) {
        throw Error("Selecione o objeto inteligente da tipografia.");
    }
    var s = stringIDToTypeID, c = charIDToTypeID;
    var filtro = new ActionDescriptor();
    var tela = new ActionDescriptor();
    tela.putInteger(c("Top "), 0);
    tela.putInteger(c("Left"), 0);
    tela.putInteger(c("Rght"), Math.round(doc.width.as("px")));
    tela.putInteger(c("Btom"), Math.round(doc.height.as("px")));
    filtro.putObject(s("referenceRect"), c("Rctn"), tela);
    filtro.putBoolean(s("blurbType"), true);
    filtro.putInteger(c("VrsM"), 1);
    filtro.putInteger(c("VrsN"), 0);
    filtro.putInteger(s("blurbOpenPanel"), 0);
    filtro.putBoolean(s("blurbGeneralBlurEffectApplied"), true);
    filtro.putBoolean(s("blurbSaveMaskChannel"), false);
    filtro.putBoolean(s("blurbHighQuality"), true);
    var lista = new ActionList();
    for (var i = 0; i < pinos.length; i++) {
        var p = new ActionDescriptor();
        p.putInteger(s("blurbWidgetType"), 0);
        p.putDouble(s("blurbWidgetLocationX"), pinos[i][0]);
        p.putDouble(s("blurbWidgetLocationY"), pinos[i][1]);
        p.putDouble(s("blurbGeneralBlurAmount"), pinos[i][2]);
        p.putBoolean(s("blurbWidgetEffectEnabled"), true);
        p.putBoolean(s("blurbWidgetSelected"), i === pinos.length - 1);
        lista.putObject(s("blurbWidget"), p);
    }
    filtro.putList(s("blurbWidgetList"), lista);
    executeAction(s("blurbTransform"), filtro, DialogModes.NO);
}
~~~

Para alterar pinos existentes, ler smartObject → filterFX na camada e identificar o filtro cujo objeto Fltr é blurbTransform. A função acima **adiciona** um filtro. No teste com um único filtro de campo, guardar o estado do histórico, remover a instância identificada e reaplicar com as novas coordenadas. Em caso de erro, restaurar o estado anterior antes de salvar. Se houver outros efeitos de galeria ou filtros na pilha, preservar os demais parâmetros e a ordem.

Antes de entregar, conferir a lista blurbWidgetList na camada salva: quantidade, coordenadas e raios. Na prévia, comparar a borda de uma letra sobre o fundo com outra vista pelo vidro. Conferir também se a impressão da garrafa e a textura do metal continuam nítidas.

## Aplicar pelo PowerShell em um PSD aberto

Selecionar a palavra no Photoshop, abrir o PowerShell na pasta desta skill e executar com os nomes do documento e da camada ativos. Medir os pontos no documento, em pixels. Neste exemplo, aproximar a palavra da garrafa aumenta o desfoque.

~~~powershell
.\scripts\aplicar-desfoque.ps1 -Documento 'Teste.psd' -Camada 'Como usar' -PinosJson '[[102,810,0],[345,733,4],[505,701,12]]'
~~~

No Photoshop Beta, acrescentar `-Programa Photoshop.Application.BETA`. O comando converte texto em objeto inteligente quando necessário, substitui um único filtro de campo existente e confere o total de pinos. A alteração fica visível no documento para inspeção e salvamento pelo designer. Em uma pilha com efeitos adicionais, inspecionar a Galeria da camada antes de ajustar.
