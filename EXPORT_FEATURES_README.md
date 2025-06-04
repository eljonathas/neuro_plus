# Funcionalidades de Exportação - Neuro Plus

Este documento descreve as funcionalidades de exportação e compartilhamento implementadas no aplicativo Neuro Plus.

## 📋 Funcionalidades Implementadas

### 1. Exportação de Dados

- **Consultas**: Exportação em CSV e JSON
- **Pacientes**: Exportação em CSV
- **Protocolos**: Exportação em CSV e compartilhamento via QR Code

### 2. Compartilhamento de Protocolos

- **QR Code**: Geração de QR Code para compartilhar protocolos entre usuários
- **Scanner**: Funcionalidade para escanear e importar protocolos via QR Code
- **Validação**: Verificação de protocolos duplicados antes da importação

## 🏗️ Arquitetura

### Serviços

- **`ExportService`**: Serviço centralizado para todas as funcionalidades de exportação
- **Localização**: `lib/common/services/export_service.dart`

### Widgets Reutilizáveis

- **`ExportButton`**: Botão customizado para ações de exportação
- **`ExportMenuWidget`**: Menu modal com opções de exportação
- **`ProtocolQrWidget`**: Widget para exibir QR Code de protocolos
- **`QrScannerWidget`**: Widget para escanear QR Codes

### Helpers

- **`ExportOptions`**: Factory methods para criar opções comuns de exportação

## 🚀 Como Usar

### 1. Exportação Básica de Lista

```dart
import 'package:neuro_plus/common/widgets/export_menu_widget.dart';
import 'package:neuro_plus/common/services/export_service.dart';

void _showExportMenu() {
  ExportMenuWidget.show(
    context,
    title: 'Exportar Dados',
    options: [
      ExportOptions.csvExport(
        title: 'Exportar Lista (CSV)',
        data: myDataList,
        exportFunction: ExportService.exportDataToCsv,
        onSuccess: () {
          // Callback de sucesso
        },
      ),
    ],
  );
}
```

### 2. Compartilhamento de Protocolo via QR Code

```dart
import 'package:neuro_plus/common/widgets/protocol_qr_widget.dart';

void _showProtocolQrCode(Protocol protocol) {
  ProtocolQrDialog.show(context, protocol);
}
```

### 3. Scanner de QR Code para Importação

```dart
import 'package:neuro_plus/common/widgets/qr_scanner_widget.dart';

void _navigateToScanner() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => QrScannerWidget(
        onProtocolImported: (protocol) {
          // Callback quando protocolo é importado
          _reloadData();
        },
      ),
    ),
  );
}
```

### 4. Exportação Individual

```dart
Future<void> _exportSingleItem(MyData item) async {
  try {
    final file = await ExportService.exportItemToJson(item);
    await ExportService.shareFile(file);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item exportado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}
```

## 📱 Integração nas Telas

### Protocolos (Implementado)

- ✅ Botão de exportação no header
- ✅ Menu com opções CSV e importação via QR
- ✅ Botão QR Code em cada card de protocolo
- ✅ Scanner integrado para importação

### Consultas (Exemplo disponível)

- 📄 Arquivo: `lib/screens/appointments/appointments_list/appointments_list_screen_example.dart`
- 🔧 Funcionalidades: Exportação CSV de lista, JSON individual

### Pacientes (Exemplo disponível)

- 📄 Arquivo: `lib/screens/patients/patients_screen_example.dart`
- 🔧 Funcionalidades: Exportação CSV de lista

## 🔧 Configuração

### Dependências Necessárias

```yaml
dependencies:
  # Já incluídas no pubspec.yaml
  qr_flutter: ^4.1.0
  mobile_scanner: ^7.0.0
  share_plus: ^11.0.0
  path: ^1.9.0
  csv: ^6.0.0
  permission_handler: ^11.3.1
```

### Permissões (Android)

Adicione no `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## 📊 Formatos de Exportação

### CSV (Planilhas)

- **Consultas**: ID, Paciente, Data, Horário, Status, Tipo, etc.
- **Pacientes**: ID, Nome, Idade, Responsáveis, Contatos, etc.
- **Protocolos**: ID, Nome, Descrição, Categorias, Itens, etc.

### JSON (Dados Estruturados)

- **Consultas**: Dados completos incluindo respostas de protocolos
- **Protocolos**: Estrutura completa para compartilhamento

### QR Code (Protocolos)

```json
{
  "type": "protocol_share",
  "version": "1.0",
  "data": {
    /* dados do protocolo */
  },
  "sharedAt": "2024-01-01T00:00:00.000Z"
}
```

## 🎨 Padrões de UI

### Cores dos Botões

- **CSV**: Verde (`Colors.green`)
- **JSON**: Azul (`Colors.blue`)
- **QR Code**: Roxo (`Colors.purple`)
- **Scanner**: Laranja (`Colors.orange`)

### Ícones

- **Exportar**: `Icons.file_download`
- **QR Code**: `Icons.qr_code`
- **Scanner**: `Icons.qr_code_scanner`
- **CSV**: `Icons.table_chart`
- **JSON**: `Icons.code`

## 🔒 Segurança e Validação

### Importação de Protocolos

- ✅ Validação do tipo de QR Code
- ✅ Verificação de protocolos duplicados
- ✅ Confirmação antes da substituição
- ✅ Tratamento de erros

### Permissões

- ✅ Solicitação automática de permissões de armazenamento
- ✅ Fallback para diretório de documentos da app

## 🚀 Próximos Passos

1. **Integrar nas telas existentes**: Aplicar os exemplos nas telas reais
2. **Testes**: Implementar testes unitários para os serviços
3. **Melhorias de UX**: Adicionar indicadores de progresso
4. **Backup/Restore**: Funcionalidade completa de backup
5. **Filtros de exportação**: Permitir exportação por período/status

## 📝 Notas de Implementação

### Escalabilidade

- Serviços modulares e reutilizáveis
- Widgets compostos seguindo Single Responsibility
- Factory methods para facilitar extensão

### Manutenibilidade

- Separação clara entre UI e lógica de negócio
- Tratamento consistente de erros
- Documentação inline nos métodos principais

### Performance

- Widgets const quando possível
- Lazy loading de dados
- Otimização de builds com ValueKey
