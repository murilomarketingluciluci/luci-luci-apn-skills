[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Documento,
    [Parameter(Mandatory)][string]$Camada,
    [Parameter(Mandatory)][string]$PinosJson,
    [ValidateSet('Photoshop.Application','Photoshop.Application.BETA')]
    [string]$Programa = 'Photoshop.Application'
)
$ErrorActionPreference = 'Stop'
$dados = ConvertFrom-Json -InputObject $PinosJson
if ($dados.Count -lt 2) { throw 'Defina dois ou mais pinos para uma transição de foco.' }
foreach ($pino in $dados) {
    if ($pino.Count -ne 3) { throw 'Cada pino deve conter X, Y e raio em pixels.' }
    foreach ($n in $pino) {
        if ($n -isnot [ValueType] -or $n -is [bool] -or [double]::IsNaN($n) -or [double]::IsInfinity($n)) {
            throw 'As coordenadas e os raios devem ser números finitos.'
        }
    }
    if ($pino[2] -lt 0 -or $pino[2] -gt 500) { throw 'Informe um raio entre 0 e 500 px.' }
}
$argumentos = @{ documento=$Documento; camada=$Camada; pinos=$dados } | ConvertTo-Json -Depth 5 -Compress
$funcao = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'desfoque-de-campo.jsx') -Encoding UTF8
$aplicar = @"
(function (cfg) {
    var d = app.activeDocument, l = d.activeLayer, s = stringIDToTypeID, c = charIDToTypeID;
    if (d.name !== cfg.documento || l.name !== cfg.camada) throw Error("Selecione o documento e a camada indicados.");
    var historico = d.activeHistoryState;
    try {
        if (l.kind === LayerKind.TEXT) {
            executeAction(s("newPlacedLayer"), undefined, DialogModes.NO);
            l = d.activeLayer;
        }
        if (l.kind !== LayerKind.SMARTOBJECT) throw Error("Selecione texto ou objeto inteligente.");
        var ref = new ActionReference();
        ref.putIdentifier(s("layer"), l.id);
        var so = executeActionGet(ref).getObjectValue(s("smartObject"));
        if (so.hasKey(s("filterFX"))) {
            var filtros = so.getList(s("filterFX"));
            if (filtros.count > 0) {
                if (filtros.count !== 1 || filtros.getObjectValue(0).getObjectType(c("Fltr")) !== s("blurbTransform"))
                    throw Error("Confira a pilha de filtros antes de alterar esta camada.");
                var filtro = filtros.getObjectValue(0).getObjectValue(c("Fltr"));
                var existentes = filtro.getList(s("blurbWidgetList"));
                for (var i = 0; i < existentes.count; i++) {
                    if (existentes.getObjectValue(i).getInteger(s("blurbWidgetType")) !== 0)
                        throw Error("A galeria contém outros tipos de desfoque.");
                }
                var rm = new ActionDescriptor(), rr = new ActionReference();
                rr.putIndex(s("filterFX"),1);
                rr.putIdentifier(s("layer"),l.id);
                rm.putReference(c("null"),rr);
                executeAction(c("Dlt "),rm,DialogModes.NO);
            }
        }
        aplicarDesfoqueDeCampo(cfg.pinos);
        var finalSO = executeActionGet(ref).getObjectValue(s("smartObject"));
        var widgets = finalSO.getList(s("filterFX")).getObjectValue(0).getObjectValue(c("Fltr")).getList(s("blurbWidgetList"));
        if (widgets.count !== cfg.pinos.length) throw Error("Quantidade de pinos divergente.");
        app.refresh();
        return widgets.count + " pinos na camada " + l.name;
    } catch (erro) {
        d.activeHistoryState = historico;
        throw erro;
    }
})($argumentos)
"@
$ps = New-Object -ComObject $Programa
$ps.DoJavaScript($funcao + [Environment]::NewLine + $aplicar)
