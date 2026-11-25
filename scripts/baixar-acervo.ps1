[CmdletBinding()]
param(
    [string] $Destino = (Join-Path (Split-Path -Parent $PSScriptRoot) 'acervo'),
    [string[]] $Arquivo
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$release = 'https://github.com/murilomarketingluciluci/luci-luci-apn-skills/releases/download/v1.0.0'
$manifesto = Join-Path (Split-Path -Parent $PSScriptRoot) 'acervo-manifesto.json'
$dados = Get-Content -Raw -LiteralPath $manifesto -Encoding UTF8 | ConvertFrom-Json
$lista = @($dados)
# Windows PowerShell 5.1 pode usar um protocolo TLS antigo por padrao.
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

function Test-ArquivoIntegro {
    param([string] $Caminho, $Registro)
    if (-not [IO.File]::Exists($Caminho)) { return $false }
    if ((Get-Item -LiteralPath $Caminho).Length -ne [long]$Registro.bytes) { return $false }
    return (Get-FileHash -LiteralPath $Caminho -Algorithm SHA256).Hash -eq $Registro.sha256
}

if (-not $lista.Count) { throw 'Manifesto do acervo vazio.' }
$nomes = @{}
foreach ($registro in $lista) {
    $nome = [string]$registro.arquivo
    if ($nome -notmatch '^[a-zA-Z0-9_-][a-zA-Z0-9._-]*$' -or $nome.EndsWith('.') -or
        $nomes.ContainsKey($nome) -or $registro.sha256 -notmatch '^[a-fA-F0-9]{64}$' -or
        [long]$registro.bytes -le 0) {
        throw "Entrada invalida no manifesto: $nome"
    }
    $nomes[$nome] = $true
}
foreach ($nome in $Arquivo) {
    if (-not $nomes.ContainsKey($nome)) {
        throw "Arquivo ausente no manifesto: $nome. Opcoes: $($nomes.Keys -join ', ')"
    }
}

$pasta = [IO.Directory]::CreateDirectory($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destino)).FullName
foreach ($registro in $lista) {
    $nome = $registro.arquivo
    if ($Arquivo -and $nome -notin $Arquivo) { continue }
    $alvo = Join-Path $pasta $nome
    if (Test-ArquivoIntegro $alvo $registro) {
        Write-Output "Verificado: $nome"
        continue
    }

    # Baixar na mesma unidade permite publicar o arquivo verificado de uma vez.
    $temporario = Join-Path $pasta ('.' + $nome + '.' + [Guid]::NewGuid().ToString('N') + '.part')
    try {
        Write-Output "Baixando: $nome"
        Invoke-WebRequest -UseBasicParsing -Uri "$release/$([Uri]::EscapeDataString($nome))" -OutFile $temporario
        if (-not (Test-ArquivoIntegro $temporario $registro)) {
            throw "Tamanho ou SHA-256 divergente: $nome"
        }
        if ([IO.File]::Exists($alvo)) {
            [IO.File]::Replace($temporario, $alvo, [System.Management.Automation.Language.NullString]::Value)
        } else {
            try {
                [IO.File]::Move($temporario, $alvo)
            } catch [IO.IOException] {
                if (-not (Test-ArquivoIntegro $alvo $registro)) { throw }
            }
        }
        Write-Output "Disponivel: $alvo"
    } finally {
        if ([IO.File]::Exists($temporario)) { [IO.File]::Delete($temporario) }
    }
}
