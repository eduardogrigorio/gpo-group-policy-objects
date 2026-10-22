# GPO - Group Policy Objects

Catálogo versionado de políticas de grupo para ambientes Windows/Active Directory. O repositório reúne procedimentos, templates e scripts de apoio para implantação controlada de GPOs em endpoints e servidores.

> **Importante:** este repositório contém modelos genéricos. Substitua os placeholders pelos nomes do domínio, servidores, compartilhamentos, impressoras e unidades organizacionais reais somente durante a implantação controlada.

## Objetivos

- Padronizar a documentação e o ciclo de vida das GPOs.
- Facilitar revisão, homologação, implantação e rollback.
- Manter scripts reutilizáveis para tarefas recorrentes.
- Evitar alterações manuais não documentadas no ambiente Active Directory.
- Criar uma base para futuras políticas de segurança, configuração e conformidade.

## Conteúdo inicial

| GPO | Finalidade | Método recomendado |
|---|---|---|
| `GPO-USER-Wallpaper` | Aplicar wallpaper corporativo nos endpoints Windows | Group Policy Preferences ou script de logon |
| `GPO-USER-MapPrinters` | Mapear impressoras por usuário, grupo ou unidade organizacional | Group Policy Preferences - Printers |
| `GPO-COMPUTER-CopyManagedFiles` | Distribuir arquivos aprovados para endpoints | Group Policy Preferences - Files ou script de inicialização |

## Estrutura

```text
.
├── README.md
├── GPO/
│   ├── endpoints/
│   │   └── wallpaper/
│   ├── impressoras/
│   │   └── mapeamento/
│   ├── arquivos/
│   │   └── copia/
│   ├── seguranca/
│   ├── rede/
│   ├── software/
│   ├── usuarios/
│   └── servidores/
├── docs/
│   └── governanca-e-implantacao.md
├── scripts/
│   ├── endpoints/
│   ├── impressoras/
│   └── arquivos/
├── templates/
│   ├── catalogo/
│   └── controle-de-mudancas/
└── backups/
    └── .gitkeep
```

As GPOs ficam agrupadas em `GPO/`, que é o diretório principal do catálogo. Cada subdiretório representa um tema, como endpoints, impressoras, arquivos, segurança, rede, software, usuários ou servidores. Os diretórios `scripts/`, `templates/` e `docs/` apoiam a implantação e a governança.

## Pré-requisitos

- Active Directory Domain Services funcionando e replicando corretamente.
- Console **Group Policy Management** (`gpmc.msc`) disponível para os administradores autorizados.
- Estação ou servidor de administração com RSAT e módulos PowerShell adequados.
- Compartilhamentos SMB com permissões NTFS e de compartilhamento revisadas.
- Grupo de teste ou OU de homologação separada da produção.
- Processo de mudança, aprovação e rollback definido.
- Windows PowerShell ou PowerShell compatível com os endpoints-alvo.

## Fluxo de trabalho obrigatório

1. **Planejar:** registrar finalidade, escopo, proprietário, dependências e impacto.
2. **Criar:** usar o padrão de nomes e a documentação em `templates/controle-de-mudancas/`.
3. **Configurar:** aplicar a menor quantidade de configurações necessária.
4. **Homologar:** vincular primeiro a uma OU ou grupo de teste.
5. **Validar:** usar `gpupdate`, `gpresult` e eventos do Windows.
6. **Revisar:** obter aprovação de outro administrador antes da produção.
7. **Implantar:** aplicar em ondas, evitando alterações globais sem janela de mudança.
8. **Monitorar:** acompanhar falhas, tempo de aplicação e impacto ao usuário.
9. **Documentar:** registrar versão, data, autor, resultado e plano de rollback.
10. **Reverter:** remover o vínculo ou restaurar a configuração anterior caso os critérios de sucesso não sejam atingidos.

## Padrão de nomes

Use nomes previsíveis e indique o escopo:

```text
GPO-USER-Wallpaper
GPO-USER-MapPrinters
GPO-COMPUTER-CopyManagedFiles
GPO-COMPUTER-Security-Baseline
GPO-USER-DriveMappings-Finance
```

Prefixos recomendados:

- `USER`: política direcionada a usuários.
- `COMPUTER`: política direcionada a computadores.
- `SECURITY`: política de segurança ou conformidade.
- `APP`: configuração de aplicação.
- `TEST`: política temporária de homologação.

## Exemplos de implantação

### Atualizar políticas no endpoint

```powershell
gpupdate.exe /force
```

Para reiniciar ou encerrar sessão somente quando necessário:

```powershell
gpupdate.exe /logoff
gpupdate.exe /boot
```

### Coletar resultado aplicado

```powershell
gpresult.exe /h "$env:TEMP\gpresult.html"
```

Ou consultar um computador remoto com permissões administrativas:

```powershell
Get-GPResultantSetOfPolicy -Computer "ENDPOINT-001" -ReportType Html -Path "C:\Temp\ENDPOINT-001-gpo.html"
```

### Fazer backup das GPOs

Execute em um equipamento administrativo com o módulo GroupPolicy:

```powershell
Import-Module GroupPolicy
Backup-GPO -All -Path "D:\GPO-Backups\$(Get-Date -Format yyyy-MM-dd)"
```

Backups reais podem conter nomes de domínio, SID, caminhos internos e configurações específicas. Não publique exports de produção neste repositório sem revisão e autorização. Use `backups/` localmente ou em armazenamento corporativo controlado.

## Segurança e governança

- Não coloque senhas, tokens, chaves privadas, arquivos de usuários ou dados pessoais no repositório.
- Não use o repositório para armazenar backups reais de produção sem sanitização e aprovação.
- Prefira permissões de leitura para usuários e computadores quando a tarefa não exigir escrita.
- Use caminhos UNC autenticados e mantenha permissões de compartilhamento e NTFS coerentes.
- Assine ou valide scripts conforme a política de execução de código da organização.
- Não desabilite antivírus, UAC, firewall ou políticas de execução para fazer uma GPO funcionar.
- Evite `-ExecutionPolicy Bypass` como solução permanente.
- Use grupos de segurança para direcionamento granular e documente filtros WMI quando aplicável.
- Defina proprietário e prazo de revisão para cada GPO.
- Remova vínculos e objetos obsoletos; não acumule GPOs sem uso.

## Critérios mínimos de aceite

Uma GPO somente deve ser promovida para produção quando:

- o comportamento esperado estiver descrito;
- a OU ou grupo de teste estiver definido;
- o resultado tiver sido validado em pelo menos um endpoint representativo;
- eventos e mensagens de erro tiverem sido revisados;
- o rollback estiver documentado;
- não houver credenciais ou dados sensíveis nos scripts;
- a mudança tiver aprovação conforme o processo interno.

## Próximas GPOs sugeridas

- Baseline de segurança do Windows.
- Configuração de Windows Update e horários de manutenção.
- Mapeamento de unidades de rede por grupo.
- Configuração de proxy e navegadores corporativos.
- Implantação de certificados internos.
- Configuração de BitLocker e recuperação de chaves.
- Restrições de dispositivos removíveis.
- Configuração de auditoria e encaminhamento de eventos.
- Padrões de tela de bloqueio e tempo de inatividade.

## Contribuição

Para adicionar uma GPO:

1. Crie um subdiretório temático dentro de `GPO/` para o assunto da política.
2. Adicione scripts apenas quando a configuração nativa da GPO não for suficiente.
3. Atualize `templates/catalogo/GPO-Catalog.csv`.
4. Inclua pré-requisitos, escopo, validação e rollback.
5. Execute revisão técnica antes do merge.

## Aviso

Os exemplos são referências técnicas e devem ser validados no laboratório da organização. A aplicação de uma GPO pode afetar muitos usuários e computadores; sempre use controle de mudanças e implantação gradual.
