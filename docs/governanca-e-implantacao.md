# Governança e implantação de GPOs

## Registro mínimo

Cada GPO deve possuir:

- nome e GUID do objeto;
- proprietário técnico e área responsável;
- finalidade e escopo;
- OUs, grupos ou filtros WMI utilizados;
- dependências, caminhos e permissões;
- data da última revisão;
- critérios de aceite;
- plano de rollback;
- referência à mudança aprovada.

Use `templates/controle-de-mudancas/GPO-Change-Record.md` para registrar cada alteração relevante.

## Homologação

1. Crie uma OU de teste protegida contra vínculos acidentais de produção.
2. Utilize um grupo pequeno, com usuários e equipamentos representativos.
3. Aplique a GPO e execute `gpupdate /force`.
4. Colete `gpresult` e eventos relacionados à aplicação de políticas.
5. Teste logon, logoff, reinicialização, conectividade e comportamento da aplicação.
6. Teste um usuário ou computador fora do escopo para garantir que a GPO não vazou.
7. Registre evidências antes da aprovação.

## Implantação em produção

- Faça a mudança em janela aprovada.
- Use links habilitados gradualmente ou grupos de segurança.
- Monitore erros de aplicação e impacto ao suporte.
- Evite editar uma GPO crítica diretamente durante uma emergência; prefira uma mudança rastreável.
- Após a implantação, atualize o catálogo e o registro de mudança.

## Backup e restauração

Para backup local:

```powershell
Import-Module GroupPolicy
$path = "D:\GPO-Backups\$(Get-Date -Format yyyy-MM-dd-HHmm)"
New-Item -ItemType Directory -Path $path -Force | Out-Null
Backup-GPO -All -Path $path
```

Para restaurar, valide primeiro o backup e o domínio de destino. A restauração pode alterar configurações amplas e deve ser executada por administrador autorizado:

```powershell
Restore-GPO -BackupId '<GUID-DO-BACKUP>' -Path 'D:\GPO-Backups\2026-01-01-1200'
```

Não publique backups reais em um repositório público. Eles podem conter detalhes de infraestrutura e identificadores internos.

## Revisão periódica

Revise cada GPO pelo menos de acordo com a política interna e sempre que houver:

- alteração de domínio ou OU;
- mudança de servidor de arquivos ou impressão;
- atualização relevante do Windows;
- troca de aplicação ou driver;
- incidente de segurança;
- mudança de proprietário ou responsabilidade.
