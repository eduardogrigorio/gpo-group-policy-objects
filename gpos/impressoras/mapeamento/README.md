# GPO-USER-MapPrinters

Mapeia impressoras compartilhadas para usuários ou grupos de segurança.

## Preferência recomendada

Use **User Configuration → Preferences → Control Panel Settings → Printers** na GPMC quando o cenário puder ser representado por impressoras compartilhadas e direcionamento por grupo.

O script `scripts/impressoras/Map-Printer.ps1` é uma alternativa para casos em que seja necessário registrar logs, tratar exceções ou executar a lógica fora de uma preferência simples.

## Pré-requisitos

- Print Server aprovado e administrado pela equipe responsável.
- Compartilhamento de impressora publicado com nome estável.
- Drivers compatíveis e aprovados para os endpoints.
- Grupo de segurança para direcionamento, quando necessário.
- Permissões revisadas no servidor de impressão.

Exemplo de conexão:

```text
\\PRINTSERVER\PRN-FINANCEIRO
```

Substitua `PRINTSERVER` e o nome do compartilhamento pelos valores oficiais. Não use endereço IP como padrão quando um nome DNS estável estiver disponível.

## Procedimento pela GPMC

1. Crie ou edite `GPO-USER-MapPrinters`.
2. Acesse **User Configuration → Preferences → Control Panel Settings → Printers**.
3. Adicione uma impressora compartilhada.
4. Configure o caminho UNC do compartilhamento.
5. Use **Item-level targeting** para limitar a aplicação por grupo, OU, computador ou localização.
6. Defina a impressora padrão somente quando houver requisito claro.
7. Vincule a GPO à OU de homologação.
8. Promova em ondas após validar drivers e permissões.

## Script de apoio

O script recebe o nome do compartilhamento e não contém caminhos internos fixos:

```powershell
 .\scripts\impressoras\Map-Printer.ps1 -PrinterPath '\\PRINTSERVER\PRN-FINANCEIRO'
```

Use o script como logon script somente quando a preferência nativa não atender ao caso. Evite executar a instalação como administrador se a política da organização não exigir isso.

## Validação

```powershell
gpupdate.exe /force
gpresult.exe /h "$env:TEMP\printers-gpresult.html"
Get-Printer | Sort-Object Name
```

Confirme:

- a impressora aparece apenas para o grupo esperado;
- o driver é compatível e vem de origem autorizada;
- o usuário consegue imprimir sem privilégios administrativos indevidos;
- a GPO não cria conexões duplicadas;
- a remoção ou troca de impressora funciona no rollback.

## Rollback

Remova o item da preferência ou configure a ação como **Delete** para o mesmo caminho, conforme o plano de mudança. Não remova impressoras de forma ampla sem confirmar se outra GPO ou processo as administra.
