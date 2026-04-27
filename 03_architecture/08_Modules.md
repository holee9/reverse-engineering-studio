# 08. Modules

## RevEngStudio.Core

### 책임
- 도메인 모델 정의
- 외부 의존성 없는 순수 C#
- 인터페이스·추상 정의

### 주요 타입

#### Models
```csharp
public record SurfaceScanReport(
    string FileName,
    string FilePath,
    long FileSize,
    string Sha256,
    DllType Type,
    PeMetadata Metadata,
    IReadOnlyList<ExportedFunction> Exports,
    IReadOnlyList<ImportedDll> Imports,
    IReadOnlyList<SectionInfo> Sections,
    DateTimeOffset AnalyzedAt
);

public record PeMetadata(
    string Architecture,      // "x86" | "x64" | "ARM64"
    string Subsystem,
    string EntryPointRva,
    DateTimeOffset TimeStamp,
    string? FileVersion,
    string? ProductVersion
);

public record ExportedFunction(
    string Name,
    ushort Ordinal,
    string Rva
);

public record ImportedDll(
    string DllName,
    IReadOnlyList<string> Functions
);

public record SectionInfo(
    string Name,
    uint VirtualSize,
    uint RawSize,
    string Characteristics
);

public enum DllType { Managed, Native, Mixed, Unknown }
```

#### Abstractions
```csharp
public interface IAnalyzer<TReport>
{
    Task<TReport> AnalyzeAsync(string dllPath, CancellationToken ct = default);
}

public interface IExporter<TReport>
{
    Task ExportAsync(TReport report, string outputPath, CancellationToken ct = default);
    string FileExtension { get; }
}
```

---

## RevEngStudio.Analysis

### 책임
- PE/Managed/Native 분석 엔진 구현
- 외부 라이브러리 격리 계층

### 주요 클래스

#### PeLoader
```csharp
public class PeLoader : IPeLoader
{
    public LoadedPeFile Load(string path);  // PeNet 래핑
}
```

#### DllTypeDetector
```csharp
public class DllTypeDetector
{
    public DllType Detect(LoadedPeFile peFile);
}
```

#### SurfaceScanAnalyzer (L1)
```csharp
public class SurfaceScanAnalyzer : IAnalyzer<SurfaceScanReport>
{
    public SurfaceScanAnalyzer(
        IPeLoader loader,
        DllTypeDetector detector,
        IReadOnlyList<IMetadataExtractor> extractors);

    public Task<SurfaceScanReport> AnalyzeAsync(string path, CancellationToken ct);
}
```

#### ManagedAnalyzer (L2)
```csharp
public class ManagedAnalyzer : IAnalyzer<ManagedAnalysisReport>
{
    // ICSharpCode.Decompiler 래핑
    public Task<ManagedAnalysisReport> AnalyzeAsync(string path, CancellationToken ct);
}
```

#### GhidraAnalyzer (L4)
```csharp
public class GhidraAnalyzer : IAnalyzer<NativeAnalysisReport>
{
    public GhidraAnalyzer(
        GhidraProcessRunner runner,
        string ghidraInstallPath,
        string scriptPath);

    public Task<NativeAnalysisReport> AnalyzeAsync(
        string path,
        IProgress<AnalysisProgress>? progress,
        CancellationToken ct);
}
```

---

## RevEngStudio.Export

### 책임
- 리포트 직렬화
- 문서 생성 (L5)

### 주요 클래스

#### JsonExporter
```csharp
public class JsonExporter<TReport> : IExporter<TReport>
{
    public string FileExtension => ".json";
    public Task ExportAsync(TReport report, string path, CancellationToken ct);
}
```

#### MarkdownGenerator (L5)
```csharp
public class MarkdownGenerator : IDocumentGenerator
{
    public Task GenerateAsync(
        CompositeReport report,
        string templatePath,
        string outputPath);
}
```

---

## RevEngStudio.Cli

### 책임
- 명령줄 인터페이스
- System.CommandLine 기반

### 명령 구조
```
reveng-cli analyze <path> [--output <json-path>] [--format json|text] [--verbose]
reveng-cli version
reveng-cli help
```

### 종료 코드
| Code | 의미 |
|------|------|
| 0 | 성공 |
| 1 | 일반 에러 |
| 2 | 파일 없음 |
| 3 | PE 파일 아님 |
| 4 | 분석 실패 |

---

## RevEngStudio.Wpf

### 책임
- GUI 프론트엔드
- MVVM 패턴
- 사용자 입력 → Analysis 호출

### ViewModels
- `MainViewModel` — 전체 상태, 명령
- `AnalysisViewModel` — 분석 결과 표시
- `TypeDetailViewModel` — 선택 타입 상세
- `GraphViewModel` (L3) — Call Graph 상태

### Views
- `MainWindow.xaml`
- `TreeViewPanel.xaml`
- `DetailPanel.xaml`
- `GraphViewControl.xaml` (L3)

### 주요 명령
- `SelectDllCommand`
- `AnalyzeCommand`
- `ExportJsonCommand`
- `GenerateDocumentCommand` (L5)

---

## 의존성 주입

Microsoft.Extensions.DependencyInjection 기반 구성:

```csharp
services.AddSingleton<IPeLoader, PeLoader>();
services.AddSingleton<DllTypeDetector>();
services.AddTransient<IAnalyzer<SurfaceScanReport>, SurfaceScanAnalyzer>();
services.AddTransient<IAnalyzer<ManagedAnalysisReport>, ManagedAnalyzer>();
services.AddSingleton<IExporter<SurfaceScanReport>, JsonExporter<SurfaceScanReport>>();
```

## 테스트 전략

### 단위 테스트 대상
- `Core.Tests` — 모델 유효성, 직렬화
- `Analysis.Tests` — 각 Extractor, Analyzer (샘플 DLL fixture 사용)
- `Export.Tests` — JSON 스키마 준수 검증

### 통합 테스트
- 실제 샘플 DLL을 사용하는 End-to-End 테스트
- `tests/samples/` 디렉토리의 파일 경로 상수로 관리

### 테스트 커버리지 목표
| Layer | 최소 커버리지 |
|-------|--------------|
| Core | 80% |
| Analysis | 70% |
| Export | 70% |
| Cli | 50% |
| Wpf | 측정 제외 (수동 테스트) |
