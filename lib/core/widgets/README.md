# Branch Selector Widget

Widget reusable untuk memilih branch/cabang dengan style minimalis seperti Tokopedia dan **state management global**.

## Fitur

- ✅ Bottom sheet popup dengan animasi smooth
- ✅ Default selection (Karang Ploso sebagai default)
- ✅ Style minimalis dan clean
- ✅ Fully customizable
- ✅ Responsive design
- ✅ Handle bar untuk drag gesture
- ✅ Close button untuk dismiss
- ✅ **Global State Management** - Semua widget terhubung
- ✅ **Auto Search** - Otomatis fetch data berdasarkan branch aktif
- ✅ **Branch ID Integration** - Data sesuai dengan branch yang dipilih

## Global State Management

Widget ini menggunakan `GlobalBranchProvider` untuk mengelola state branch secara global. Ketika satu halaman mengganti branch, semua halaman lain akan otomatis menggunakan branch yang sama.

### Cara Kerja:

1. **Global Provider**: `GlobalBranchProvider` menyimpan branch yang aktif
2. **Shared State**: Semua widget BranchSelector menggunakan state yang sama
3. **Auto Update**: Ketika branch berubah, semua halaman otomatis update
4. **Auto Search**: Setiap halaman otomatis fetch data berdasarkan branch aktif

## Penggunaan

### Basic Usage (Updated)

```dart
import 'package:your_app/core/widgets/branch_selector.dart';
import 'package:your_app/core/providers/global_branch_provider.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
    // Auto search based on global branch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final globalBranchProvider = Provider.of<GlobalBranchProvider>(context, listen: false);
      // Fetch data based on current branch
      print('Current branch: ${globalBranchProvider.currentBranchName}');
    });
  }

  void _onBranchSelected(BranchModel branch) {
    // Branch selection is handled globally
    print('Branch selected: ${branch.branchName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BranchSelector(
          onBranchSelected: _onBranchSelected,
          title: 'Pilih Cabang',
          hintText: 'Cabang',
        ),
      ),
    );
  }
}
```

### Global Provider Setup

Pastikan `GlobalBranchProvider` sudah di-setup di `main.dart`:

```dart
MultiProvider(
  providers: [
    // ... other providers
    ChangeNotifierProvider(
      create: (_) => GlobalBranchProvider(),
    ),
  ],
  child: MaterialApp.router(
    // ... app configuration
  ),
)
```

## Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `onBranchSelected` | `Function(BranchModel)?` | ❌ | Callback when branch is selected |
| `title` | `String?` | ❌ | Title for bottom sheet (default: 'Pilih Cabang') |
| `hintText` | `String?` | ❌ | Hint text for selector (default: 'Pilih Cabang') |

## GlobalBranchProvider

```dart
class GlobalBranchProvider extends ChangeNotifier {
  BranchModel? _selectedBranch;
  final List<BranchModel> branches = [
    BranchModel(branchId: 1, branchName: 'Karang Ploso'),
    BranchModel(branchId: 2, branchName: 'Pakisaji'),
  ];

  BranchModel? get selectedBranch => _selectedBranch;
  List<BranchModel> get availableBranches => branches;
  int get currentBranchId => _selectedBranch?.branchId ?? 1;
  String get currentBranchName => _selectedBranch?.branchName ?? 'Karang Ploso';

  void setSelectedBranch(BranchModel branch) {
    _selectedBranch = branch;
    notifyListeners();
  }
}
```

## Auto Search & Branch ID Integration

### Saat Halaman Dibuka:
- Otomatis menggunakan branch yang aktif dari `GlobalBranchProvider`
- Auto fetch data dengan `branchId` yang sesuai
- Data yang ditampilkan sesuai dengan branch yang dipilih

### Saat Branch Berubah:
- Update `GlobalBranchProvider` dengan branch baru
- Semua halaman otomatis menggunakan branch yang sama
- Auto refresh data di semua halaman

## Styling

Widget ini menggunakan style yang konsisten dengan design system:

- **Colors**: Blue theme untuk selection
- **Typography**: Clean dan readable
- **Spacing**: Consistent padding dan margin
- **Animation**: Smooth bottom sheet transition
- **Icons**: Material Design icons

## Dependencies

Pastikan dependencies berikut sudah ada di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
```

## Contoh Implementasi

Widget ini sudah diimplementasikan di:

1. **Home Page** (`lib/features/main_menu/presentation/pages/home_page.dart`)
2. **RTL List Page** (`lib/features/rtl/presentation/pages/rtl_list_page.dart`)
3. **GRS List Page** (`lib/features/grs/presentation/pages/grs_list_page.dart`)
4. **RSK List Page** (`lib/features/rsk/presentation/pages/rsk_list_page.dart`)
5. **Stock Opname List Page** (`lib/features/stock_opname/presentation/pages/stock_opname_list_page.dart`)

## Flow Kerja Global State

1. **Aplikasi Start**: `GlobalBranchProvider` di-setup dengan default branch (Karang Ploso)
2. **Halaman Dibuka**: Widget menggunakan branch dari `GlobalBranchProvider`
3. **Branch Berubah**: Semua widget otomatis update ke branch yang sama
4. **Data Fetch**: Setiap halaman fetch data berdasarkan `currentBranchId`
5. **UI Update**: Semua halaman menampilkan data sesuai branch aktif

## Notes

- ✅ **Global State**: Semua widget terhubung dan menggunakan state yang sama
- ✅ **Auto Search**: Otomatis fetch data saat halaman dibuka dan branch berubah
- ✅ **Branch ID Integration**: Data selalu sesuai dengan branch yang aktif
- ✅ **Real-time Sync**: Perubahan branch langsung terlihat di semua halaman
- ✅ **Consistent UX**: Pengalaman pengguna yang konsisten di seluruh aplikasi