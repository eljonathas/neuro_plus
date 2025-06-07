# Formulário de Pacientes - Arquitetura Refatorada

## Visão Geral

O formulário de pacientes foi refatorado seguindo princípios de arquitetura limpa e MVVM para melhorar a escalabilidade, manutenibilidade e testabilidade do código.

## Estrutura da Arquitetura

### 1. **Modelos de Dados** (`models/`)

- `PatientFormData` - Centraliza todos os controllers e dados do formulário
- Responsável por conversão entre Patient e dados do formulário
- Gerencia lifecycle dos TextEditingControllers

### 2. **Controladores** (`controllers/`)

- `PatientFormController` - Gerencia estado e lógica de negócio
- Implementa ChangeNotifier para reatividade
- Separa lógica de validação, salvamento e manipulação de estado

### 3. **Validadores** (`validators/`)

- `PatientFormValidators` - Validações reutilizáveis
- Funções estáticas para diferentes tipos de campo
- Facilita testes e reutilização

### 4. **Widgets de UI** (`widgets/`)

- `PatientFormProgress` - Indicador de progresso
- `PatientFormNavigation` - Navegação entre páginas
- Widgets de seção já existentes (basic_info, clinical_info, etc.)

### 5. **Tela Principal**

- `PatientsCreateScreen` - Focada apenas na UI
- Usa ListenableBuilder para reatividade
- Delega lógica para o controller

## Benefícios da Refatoração

### ✅ **Separação de Responsabilidades**

- UI isolada da lógica de negócio
- Cada classe tem uma única responsabilidade
- Facilita testes unitários

### ✅ **Reutilização**

- Validadores podem ser usados em outros formulários
- Componentes de navegação e progresso são reutilizáveis
- FormData pode ser usado em diferentes contextos

### ✅ **Manutenibilidade**

- Código mais limpo e organizado
- Fácil localização de bugs
- Modificações isoladas por responsabilidade

### ✅ **Testabilidade**

- Controller pode ser testado independentemente
- Validadores são funções puras
- UI pode ser testada com mocks

### ✅ **Escalabilidade**

- Nova arquitetura suporta facilmente novas funcionalidades
- Padrão pode ser aplicado a outros formulários
- Fácil adição de novos validadores ou campos

## Comparação de Linhas de Código

| Arquivo                       | Antes      | Depois        | Redução |
| ----------------------------- | ---------- | ------------- | ------- |
| `patients_create_screen.dart` | 600 linhas | ~200 linhas   | 67%     |
| **Total**                     | 600 linhas | ~450 linhas\* | 25%     |

\*Total distribuído entre 6 arquivos modulares

## Uso

```dart
// Inicialização do controller
final controller = PatientFormController();
controller.initialize(existingPatient);

// Uso em widgets
ListenableBuilder(
  listenable: controller,
  builder: (context, _) {
    return YourWidget(
      data: controller.formData,
      onUpdate: controller.updateField,
    );
  },
)

// Validação
final isValid = PatientFormValidators.requiredValidator(value);

// Salvamento
final success = await controller.savePatient(existingPatient);
```

## Próximos Passos Sugeridos

1. **Implementar Provider/Riverpod** para injeção de dependência
2. **Adicionar testes unitários** para controller e validadores
3. **Extrair constants** para valores mágicos
4. **Implementar cache local** para dados do formulário
5. **Adicionar loading states** mais granulares
