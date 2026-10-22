# Catálogo de GPOs

Cada subdiretório representa uma área funcional. Uma nova GPO deve ter sua documentação, pré-requisitos, validação e rollback dentro da área correspondente.

| Diretório | Conteúdo |
|---|---|
| `endpoints/` | Configurações aplicadas às estações Windows, como wallpaper e tela de bloqueio. |
| `impressoras/` | Mapeamento, instalação e remoção de impressoras compartilhadas. |
| `arquivos/` | Cópia, distribuição e atualização de arquivos gerenciados. |
| `seguranca/` | Baselines, auditoria, BitLocker, firewall e controles de segurança. |
| `rede/` | Proxy, DNS, Wi-Fi, VPN e outras configurações de conectividade. |
| `software/` | Implantação e configuração de aplicações corporativas. |
| `usuarios/` | Políticas direcionadas a perfis e sessões de usuários. |
| `servidores/` | Políticas específicas para servidores, separadas das estações. |

Use nomes iniciados por `GPO-USER-`, `GPO-COMPUTER-`, `GPO-SECURITY-` ou `GPO-TEST-`, conforme o escopo.
