# 07. Architecture

## 레이어드 아키텍처

```
┌─────────────────────────────────────────┐
│  Presentation Layer                     │
│  - RevEngStudio.Wpf (L2+)              │
│  - RevEngStudio.Cli (L1+)              │
├─────────────────────────────────────────┤
│  Application Layer                      │
│  - Analyzers (오케스트레이션)             │
│  - Document Generators (L5)            │
├─────────────────────────────────────────┤
│  Domain Layer                           │
│  - Models (Report, Type, Method...)    │
│  - Interfaces (IAnalyzer, IExporter...) │
├─────────────────────────────────────────┤
│  Infrastructure Layer                   │
│  - PE Parser (PeNet)                   │
│  - Decompiler (ICSharpCode.Decompiler) │
│  - Ghidra Wrapper (L4)                 │
│  - dumpbin Wrapper (L4)                │
└─────────────────────────────────────────┘
```

## 프로젝트 구조

```
RevEngStudio/
├── src/
│   ├── RevEngStudio.Core/           # 도메인 모델, 인터페이스
│   │   ├── Models/
│   │   │   ├── Pe/                  # PE 관련 모델
│   │   │   ├── Managed/             # C# 분석 모델
│   │   │   ├── Native/              # C++ 분석 모델
│   │   │   └── Report/              # 통합 리포트
│   │   └── Abstractions/
│   │       ├── IAnalyzer.cs
│   │       ├── IExporter.cs
│   │       └── IDocumentGenerator.cs
│   │
│   ├── RevEngStudio.Analysis/       # 분석 엔진 구현
│   │   ├── Pe/
│   │   │   ├── PeLoader.cs
│   │   │   ├── DllTypeDetector.cs
│   │   │   └── PeMetadataExtractor.cs
│   │   ├── Managed/
│   │   │   ├── ManagedAnalyzer.cs
│   │   │   ├── TypeExtractor.cs
│   │   │   ├── MethodExtractor.cs
│   │   │   └── PInvokeExtractor.cs
│   │   ├── Native/                  # L4+
│   │   │   ├── GhidraAnalyzer.cs
│   │   │   ├── GhidraProcessRunner.cs
│   │   │   └── DumpbinAnalyzer.cs
│   │   └── SurfaceScanAnalyzer.cs  # 통합 오케스트레이터
│   │
│   ├── RevEngStudio.Export/         # 직렬화, 문서 생성
│   │   ├── JsonExporter.cs
│   │   ├── MarkdownGenerator.cs    # L5+
│   │   └── Templates/
│   │
│   ├── RevEngStudio.Cli/            # L1+
│   │   ├── Program.cs
│   │   ├── Commands/
│   │   └── Formatters/
│   │
│   └── RevEngStudio.Wpf/            # L2+
│       ├── App.xaml
│       ├── Views/
│       ├── ViewModels/
│       ├── Controls/
│       └── Converters/
│
├── tests/
│   ├── RevEngStudio.Core.Tests/
│   ├── RevEngStudio.Analysis.Tests/
│   ├── RevEngStudio.Export.Tests/
│   └── samples/                    # 테스트용 DLL 샘플
│
├── docs/
├── scripts/
│   ├── setup-labels.sh
│   └── build-release.ps1
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   └── release.yml
│   ├── ISSUE_TEMPLATE/
│   └── pull_request_template.md
│
├── Directory.Packages.props        # 중앙 패키지 버전 관리
├── Directory.Build.props
├── RevEngStudio.sln
└── README.md
```

## 의존성 방향

```
Wpf ─┐
     ├──→ Analysis ──→ Core
Cli ─┘        │
              └────→ Export ──→ Core
```

**규칙**:
- Core는 외부 의존성 최소화 (필수만)
- Analysis는 PeNet, ICSharpCode.Decompiler 등 외부 라이브러리 격리
- Cli/Wpf는 Analysis만 참조, 내부 구현 몰라야 함

## 확장 포인트 (인터페이스 기반)

### IAnalyzer
```csharp
public interface IAnalyzer<TReport>
{
    Task<TReport> AnalyzeAsync(string dllPath, CancellationToken ct = default);
    bool CanAnalyze(DllType type);
}
```

### IExporter
```csharp
public interface IExporter<TReport>
{
    Task ExportAsync(TReport report, string outputPath);
    string FileExtension { get; }
}
```

### IProgressReporter
```csharp
public interface IProgressReporter
{
    void Report(int percent, string message);
}
```

## 데이터 흐름 (L1 기준)

```
CLI Input
  │
  ▼
PeLoader.Load(path)
  │
  ▼
DllTypeDetector.Detect()
  │
  ▼
SurfaceScanAnalyzer
  ├─→ PeMetadataExtractor
  ├─→ ExportExtractor
  ├─→ ImportExtractor
  └─→ SectionExtractor
  │
  ▼
SurfaceScanReport (통합)
  │
  ▼
JsonExporter → .json 파일
ConsoleFormatter → stdout
```

## L2 이후 데이터 흐름

```
DllTypeDetector
  │
  ├── Managed → ManagedAnalyzer (ILSpy)
  ├── Native  → NativeAnalyzer (Ghidra, L4)
  └── Mixed   → 둘 다 실행
       │
       ▼
   CompositeReport (통합)
       │
       ├─→ WPF Viewer (TreeView + Detail)
       ├─→ JSON Export
       └─→ Markdown/Doc (L5)
```
