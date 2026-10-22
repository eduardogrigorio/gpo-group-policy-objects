# GPO-COMPUTER-CopyManagedFiles

Distribui arquivos aprovados para endpoints Windows usando Group Policy Preferences ou um script de inicialização.

## Quando usar

- Distribuir um arquivo de configuração não secreto.
- Entregar um certificado público ou recurso corporativo aprovado.
- Colocar um instalador ou dependência em uma pasta local antes de outra etapa controlada.
- Atualizar um arquivo gerenciado com versão conhecida.

Não use este procedimento para copiar senhas, tokens, chaves privadas, arquivos pessoais ou dados sensíveis.

## Preferência recomendada

Para arquivos simples, use **Computer Configuration → Preferences → Windows Settings → Files**:

1. Crie ou edite `GPO-COMPUTER-CopyManagedFiles`.
2. Acesse **Computer Configuration → Preferences → Windows Settings → Files**.
3. Crie um item com ação `Update`.
4. Informe a origem UNC autorizada e o destino local.
5. Defina a ação para substituir apenas quando a versão aprovada tiver mudado.
6. Vincule inicialmente a uma OU de homologação.

Exemplo de origem e destino:

```text
Origem:  \\FILESERVER\Software\Managed\appsettings.json
Destino: C:\ProgramData\Empresa\appsettings.json
```

Ajuste permissões para que computadores autenticados possam ler a origem, sem conceder escrita ampla.

## Script de apoio

Para lógica adicional, use `scripts/arquivos/Copy-ManagedFile.ps1`:

```powershell
 .\scripts\arquivos\Copy-ManagedFile.ps1 `
  -SourcePath '\\FILESERVER\Software\Managed\appsettings.json' `
  -DestinationPath 'C:\ProgramData\Empresa\appsettings.json'
```

O script cria a pasta de destino, copia para um arquivo temporário e substitui o destino após a cópia. A origem deve ser um compartilhamento controlado e o arquivo deve ser validado antes da publicação.

## Validação

```powershell
gpupdate.exe /force
Get-Item 'C:\ProgramData\Empresa\appsettings.json'
Get-FileHash 'C:\ProgramData\Empresa\appsettings.json' -Algorithm SHA256
```

Compare o hash com o valor aprovado no registro de mudança quando a integridade for importante.

## Rollback

- Publique a versão anterior aprovada; ou
- remova o item da GPO e exclua o arquivo local somente se ele não for usado por outra aplicação.

Registre a versão anterior antes de promover uma atualização.
