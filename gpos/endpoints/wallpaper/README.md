# GPO-USER-Wallpaper

Aplica um wallpaper corporativo em estações Windows por usuário.

## Preferência recomendada

Quando o arquivo e o comportamento forem estáveis, prefira **Group Policy Preferences → User Configuration → Preferences → Windows Settings → Files** para distribuir a imagem e **User Configuration → Administrative Templates → Desktop → Desktop → Desktop Wallpaper** para configurar o caminho.

Se for necessário criar a pasta, validar o arquivo ou tratar exceções, use o script `scripts/endpoints/Set-Wallpaper.ps1` como script de logon.

## Pré-requisitos

- Imagem aprovada em formato `.jpg` ou `.png`.
- Compartilhamento somente leitura para usuários autenticados.
- Permissão de leitura no compartilhamento e no NTFS.
- OU ou grupo de teste.
- Definição de resolução e proporção compatíveis com os endpoints.

Exemplo de caminho, que deve ser substituído:

```text
\\FILESERVER\CorporateAssets\wallpaper.jpg
```

Não use o caminho de um computador pessoal nem um compartilhamento com permissão de escrita para todos.

## Procedimento pela GPMC

1. Abra `gpmc.msc`.
2. Crie ou edite `GPO-USER-Wallpaper`.
3. Navegue até **User Configuration → Administrative Templates → Desktop → Desktop**.
4. Abra **Desktop Wallpaper** e habilite a política.
5. Informe o caminho UNC do arquivo aprovado.
6. Escolha o estilo adequado, como `Fill`, `Fit`, `Stretch`, `Tile` ou `Center`.
7. Vincule inicialmente à OU de homologação.
8. Valide com `gpupdate /force`, encerramento e novo logon.

## Validação

```powershell
gpupdate.exe /force
gpresult.exe /h "$env:TEMP\wallpaper-gpresult.html"
```

Confirme:

- o arquivo pode ser lido pelo usuário;
- o wallpaper aparece após novo logon;
- o relatório mostra a GPO aplicada;
- usuários fora do escopo não são afetados;
- o carregamento não causa demora excessiva.

## Rollback

- Desvincule a GPO da OU de teste ou produção; ou
- defina a política como **Not Configured**; e
- remova o arquivo distribuído somente depois de confirmar que nenhuma outra GPO o utiliza.

## Boas práticas

- Não copie uma imagem diferente a cada logon sem necessidade.
- Use versionamento no nome do arquivo quando houver mudança controlada, por exemplo `wallpaper-v2.jpg`.
- Não armazene informações confidenciais, telefones pessoais ou dados internos desnecessários na imagem.
