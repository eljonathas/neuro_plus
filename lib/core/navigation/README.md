# Sistema de Roteamento Tipado

Este diretório contém o sistema de roteamento tipado da aplicação, que substitui o uso direto de `Navigator.pushNamed` com strings hardcoded.

## Classe AppRoutes

A classe `AppRoutes` centraliza todas as rotas da aplicação, mapeia widgets com suas rotas e fornece métodos tipados para navegação. O sistema trata automaticamente argumentos e parâmetros das rotas.

### Rotas Disponíveis

```dart
// Rotas principais
AppRoutes.home              // '/home'
AppRoutes.schedule          // '/schedule'
AppRoutes.protocols         // '/protocols'
AppRoutes.patients          // '/patients'

// Rotas de pacientes
AppRoutes.patientsCreate    // '/patients/create'

// Rotas de consultas
AppRoutes.appointmentsCreate  // '/appointments/create'
AppRoutes.appointmentsList    // '/appointments/list'
AppRoutes.appointmentsDetail  // '/appointments/detail'
```

### Métodos de Navegação

#### navigateTo()
Navega para uma rota específica (equivalente ao `Navigator.pushNamed`):

```dart
// Navegação simples
AppRoutes.navigateTo(context, AppRoutes.patients);

// Navegação com argumentos
AppRoutes.navigateTo(
  context, 
  AppRoutes.appointmentsDetail,
  arguments: appointment,
);
```

#### navigateAndClearStack()
Navega para uma rota e remove todas as rotas anteriores da pilha:

```dart
AppRoutes.navigateAndClearStack(context, AppRoutes.home);
```

#### navigateAndReplace()
Substitui a rota atual:

```dart
AppRoutes.navigateAndReplace(context, AppRoutes.patients);
```

#### goBack()
Volta para a tela anterior:

```dart
AppRoutes.goBack(context);

// Com resultado
AppRoutes.goBack(context, true);
```

#### canGoBack()
Verifica se é possível voltar:

```dart
if (AppRoutes.canGoBack(context)) {
  AppRoutes.goBack(context);
}
```

## Configuração no MaterialApp

No `main.dart`, simplesmente use:

```dart
MaterialApp(
  routes: AppRoutes.generateRoutes(),
  // ... outras configurações
)
```

O método `generateRoutes()` automaticamente:
- Mapeia todas as rotas com seus widgets
- Trata argumentos corretamente
- Injeta dependências necessárias

## Vantagens

1. **Tipagem**: Evita erros de digitação em nomes de rotas
2. **Autocomplete**: IDE fornece sugestões automáticas
3. **Refatoração**: Mudanças de rotas são propagadas automaticamente
4. **Centralização**: Todas as rotas e widgets ficam em um local único
5. **Manutenibilidade**: Facilita a manutenção e evolução do código
6. **Tratamento automático de argumentos**: Não precisa mapear argumentos manualmente
7. **Injeção de dependências**: Widgets recebem automaticamente os parâmetros corretos

## Migração

Para migrar código existente:

**Antes:**
```dart
Navigator.pushNamed(context, '/patients/create');
```

**Depois:**
```dart
AppRoutes.navigateTo(context, AppRoutes.patientsCreate);
```

**Antes (com argumentos):**
```dart
Navigator.pushNamed(
  context, 
  '/appointments/detail',
  arguments: appointment,
);
```

**Depois:**
```dart
AppRoutes.navigateTo(
  context,
  AppRoutes.appointmentsDetail,
  arguments: appointment,
);
``` 