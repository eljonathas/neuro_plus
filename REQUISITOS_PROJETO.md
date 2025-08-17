# Requisitos do Projeto Neuro+

## Requisitos Funcionais

### Gestão de Pacientes

**RF 01** - O sistema deve permitir cadastrar pacientes com informações básicas obrigatórias (nome completo, data de nascimento, sexo, telefone de contato, endereço)

**RF 02** - O sistema deve permitir cadastrar pacientes com informações clínicas opcionais (motivo do encaminhamento, encaminhado por, diagnóstico prévio, código CID, comorbidades)

**RF 03** - O sistema deve permitir cadastrar pacientes com informações de desenvolvimento (atraso no desenvolvimento, idade da primeira palavra, contato visual, comportamentos repetitivos, resistência à rotina, interação social, hipersensibilidade sensorial)

**RF 04** - O sistema deve permitir cadastrar pacientes com informações escolares (frequenta escola, tipo de escola, turno escolar, possui mediador)

**RF 05** - O sistema deve permitir cadastrar múltiplos responsáveis para cada paciente

**RF 06** - O sistema deve permitir editar informações de pacientes existentes

**RF 07** - O sistema deve permitir excluir pacientes

**RF 08** - O sistema deve permitir buscar pacientes por nome, diagnóstico ou outras informações

**RF 09** - O sistema deve permitir visualizar lista de todos os pacientes cadastrados

**RF 10** - O sistema deve permitir visualizar detalhes completos de um paciente específico

### Gestão de Consultas

**RF 11** - O sistema deve permitir agendar consultas com seleção de paciente, data, horário e tipo

**RF 12** - O sistema deve permitir agendar consultas com duração personalizável (padrão 60 minutos)

**RF 13** - O sistema deve permitir agendar consultas com local e observações opcionais

**RF 14** - O sistema deve permitir associar protocolos às consultas

**RF 15** - O sistema deve validar conflitos de horário antes de permitir agendamento

**RF 16** - O sistema deve permitir editar consultas existentes

**RF 17** - O sistema deve permitir cancelar consultas

**RF 18** - O sistema deve permitir atualizar status das consultas (agendada, realizada, cancelada)

**RF 19** - O sistema deve permitir buscar consultas por paciente, data, status ou tipo

**RF 20** - O sistema deve permitir visualizar lista de todas as consultas agendadas

**RF 21** - O sistema deve permitir visualizar detalhes completos de uma consulta específica

**RF 22** - O sistema deve permitir registrar respostas de protocolos durante a consulta

### Gestão de Protocolos

**RF 23** - O sistema deve permitir criar protocolos com nome, descrição e categorias

**RF 24** - O sistema deve permitir criar protocolos com itens específicos de avaliação

**RF 25** - O sistema deve permitir selecionar templates predefinidos para protocolos

**RF 26** - O sistema deve permitir editar protocolos existentes

**RF 27** - O sistema deve permitir excluir protocolos

**RF 28** - O sistema deve permitir buscar protocolos por nome ou categoria

**RF 29** - O sistema deve permitir visualizar lista de todos os protocolos cadastrados

**RF 30** - O sistema deve permitir visualizar detalhes completos de um protocolo específico

### Funcionalidades de Exportação

**RF 31** - O sistema deve permitir exportar lista de pacientes em formato CSV

**RF 32** - O sistema deve permitir exportar lista de consultas em formato CSV

**RF 33** - O sistema deve permitir exportar dados de consulta individual em formato JSON

**RF 34** - O sistema deve permitir exportar lista de protocolos em formato CSV

**RF 35** - O sistema deve permitir compartilhar protocolos via QR Code

**RF 36** - O sistema deve permitir importar protocolos escaneando QR Code

**RF 37** - O sistema deve permitir compartilhar arquivos exportados via apps nativos

### Funcionalidades de Interface

**RF 38** - O sistema deve apresentar dashboard com estatísticas de consultas (total, agendadas, realizadas, canceladas, hoje, semana)

**RF 39** - O sistema deve apresentar calendário para visualização e seleção de datas

**RF 40** - O sistema deve apresentar navegação por abas para diferentes seções do sistema

**RF 41** - O sistema deve apresentar indicadores de progresso em formulários multi-etapas

**RF 42** - O sistema deve apresentar validação em tempo real nos formulários

**RF 43** - O sistema deve apresentar mensagens de erro e sucesso para o usuário

**RF 44** - O sistema deve apresentar estados vazios quando não há dados para exibir

## Requisitos Não Funcionais

### Performance

**RNF 01** - O sistema deve responder a consultas de dados em menos de 2 segundos

**RNF 02** - O sistema deve suportar pelo menos 1000 pacientes cadastrados sem degradação de performance

**RNF 03** - O sistema deve suportar pelo menos 5000 consultas cadastradas sem degradação de performance

### Usabilidade

**RNF 04** - O sistema deve ser intuitivo para usuários com conhecimento básico de tecnologia

**RNF 05** - O sistema deve apresentar interface responsiva para diferentes tamanhos de tela

**RNF 06** - O sistema deve apresentar navegação clara e consistente entre as telas

**RNF 07** - O sistema deve apresentar feedback visual para todas as ações do usuário

### Confiabilidade

**RNF 08** - O sistema deve validar todos os dados de entrada antes de processamento

**RNF 09** - O sistema deve prevenir perda de dados durante operações de criação/edição

**RNF 10** - O sistema deve apresentar mensagens de erro claras e acionáveis

### Segurança

**RNF 11** - O sistema deve armazenar dados localmente no dispositivo do usuário

**RNF 12** - O sistema deve solicitar permissões apenas quando necessário (câmera para QR, armazenamento para exportação)

**RNF 13** - O sistema deve validar dados importados via QR Code antes de processamento

### Compatibilidade

**RNF 14** - O sistema deve funcionar em dispositivos Android com API level 21 ou superior

**RNF 15** - O sistema deve funcionar em dispositivos iOS com versão 12.0 ou superior

**RNF 16** - O sistema deve suportar orientação portrait e landscape

### Manutenibilidade

**RNF 17** - O sistema deve seguir arquitetura modular com separação clara de responsabilidades

**RNF 18** - O sistema deve utilizar padrões de design consistentes em toda a aplicação

**RNF 19** - O sistema deve implementar validações centralizadas e reutilizáveis

**RNF 20** - O sistema deve implementar tratamento de erros padronizado em todos os serviços

### Acessibilidade

**RNF 21** - O sistema deve suportar localização em português brasileiro

**RNF 22** - O sistema deve apresentar contraste adequado entre texto e fundo

**RNF 23** - O sistema deve apresentar tamanhos de fonte adequados para leitura

### Armazenamento

**RNF 24** - O sistema deve utilizar banco de dados local (Hive) para persistência de dados

**RNF 25** - O sistema deve permitir exportação de dados em formatos padrão (CSV, JSON)

**RNF 26** - O sistema deve permitir compartilhamento de dados via apps nativos do sistema

---

_Documento baseado na análise do código implementado no projeto Neuro+_
_Versão: 1.0_
_Data: Janeiro 2025_

## Classificação e Matriz de Requisitos

### Requisitos Funcionais (RF)

| ID    | Requisito                                            | Classificação |
| ----- | ---------------------------------------------------- | ------------- |
| RF 01 |                                                      | Essencial     |
| RF 02 | Cadastrar informações clínicas opcionais             | Importante    |
| RF 03 | Cadastrar informações de desenvolvimento             | Importante    |
| RF 04 | Cadastrar informações escolares                      | Importante    |
| RF 05 | Cadastrar múltiplos responsáveis por paciente        | Importante    |
| RF 06 | Editar pacientes existentes                          | Essencial     |
| RF 07 | Excluir pacientes                                    | Importante    |
| RF 08 | Buscar pacientes (nome, diagnóstico, etc.)           | Importante    |
| RF 09 | Listar todos os pacientes                            | Essencial     |
| RF 10 | Visualizar detalhes completos do paciente            | Importante    |
| RF 11 | Agendar consultas (paciente, data, horário, tipo)    | Essencial     |
| RF 12 | Duração personalizável da consulta (padrão 60 min)   | Importante    |
| RF 13 | Local e observações opcionais na consulta            | Importante    |
| RF 14 | Associar protocolos às consultas                     | Importante    |
| RF 15 | Validar conflitos de horário                         | Essencial     |
| RF 16 | Editar consultas existentes                          | Importante    |
| RF 17 | Cancelar consultas                                   | Importante    |
| RF 18 | Atualizar status das consultas                       | Importante    |
| RF 19 | Buscar consultas (paciente, data, status, tipo)      | Importante    |
| RF 20 | Listar todas as consultas agendadas                  | Essencial     |
| RF 21 | Visualizar detalhes completos de uma consulta        | Importante    |
| RF 22 | Registrar respostas de protocolos durante a consulta | Importante    |
| RF 23 | Criar protocolos (nome, descrição, categorias)       | Essencial     |
| RF 24 | Criar protocolos com itens específicos               | Essencial     |
| RF 25 | Selecionar templates de protocolos                   | Desejável     |
| RF 26 | Editar protocolos existentes                         | Importante    |
| RF 27 | Excluir protocolos                                   | Importante    |
| RF 28 | Buscar protocolos por nome/categoria                 | Importante    |
| RF 29 | Listar todos os protocolos cadastrados               | Essencial     |
| RF 30 | Visualizar detalhes completos do protocolo           | Importante    |
| RF 31 | Exportar pacientes em CSV                            | Importante    |
| RF 32 | Exportar consultas em CSV                            | Importante    |
| RF 33 | Exportar dados de consulta individual em JSON        | Desejável     |
| RF 34 | Exportar lista de protocolos em CSV                  | Importante    |
| RF 35 | Compartilhar protocolos via QR Code                  | Importante    |
| RF 36 | Importar protocolos via QR Code                      | Importante    |
| RF 37 | Compartilhar arquivos exportados via apps nativos    | Importante    |
| RF 38 | Dashboard com estatísticas de consultas              | Desejável     |
| RF 39 | Calendário para visualização/seleção de datas        | Importante    |
| RF 40 | Navegação por abas                                   | Desejável     |
| RF 41 | Indicadores de progresso em formulários multi-etapas | Importante    |
| RF 42 | Validação em tempo real nos formulários              | Importante    |
| RF 43 | Mensagens de erro e sucesso ao usuário               | Importante    |
| RF 44 | Estados vazios quando não há dados                   | Importante    |

### Requisitos Não Funcionais (RNF)

| ID     | Requisito                                              | Classificação |
| ------ | ------------------------------------------------------ | ------------- |
| RNF 01 | Resposta de consultas de dados < 2s                    | Importante    |
| RNF 02 | Suportar 1000 pacientes sem degradação                 | Importante    |
| RNF 03 | Suportar 5000 consultas sem degradação                 | Importante    |
| RNF 04 | Interface intuitiva para usuários básicos              | Importante    |
| RNF 05 | Interface responsiva                                   | Importante    |
| RNF 06 | Navegação clara e consistente                          | Importante    |
| RNF 07 | Feedback visual para ações do usuário                  | Importante    |
| RNF 08 | Validação de dados de entrada                          | Essencial     |
| RNF 09 | Prevenir perda de dados em criação/edição              | Essencial     |
| RNF 10 | Mensagens de erro claras e acionáveis                  | Importante    |
| RNF 11 | Armazenamento local dos dados                          | Importante    |
| RNF 12 | Solicitar permissões somente quando necessário         | Importante    |
| RNF 13 | Validar dados importados via QR Code                   | Importante    |
| RNF 14 | Suporte Android API ≥ 21                               | Importante    |
| RNF 15 | Suporte iOS ≥ 12.0                                     | Importante    |
| RNF 16 | Suporte a orientação portrait e landscape              | Desejável     |
| RNF 17 | Arquitetura modular com separação de responsabilidades | Essencial     |
| RNF 18 | Padrões de design consistentes                         | Importante    |
| RNF 19 | Validações centralizadas e reutilizáveis               | Essencial     |
| RNF 20 | Tratamento de erros padronizado em serviços            | Essencial     |
| RNF 21 | Localização em português brasileiro                    | Importante    |
| RNF 22 | Contraste adequado texto/fundo                         | Importante    |
| RNF 23 | Tamanhos de fonte adequados                            | Importante    |
| RNF 24 | Uso de banco local (Hive)                              | Importante    |
| RNF 25 | Exportação de dados em formatos padrão                 | Importante    |
| RNF 26 | Compartilhamento via apps nativos                      | Importante    |
