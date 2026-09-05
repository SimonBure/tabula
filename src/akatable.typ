#let caption-words = (
  en: "Table",
  zh: "表",
  ja: "表",
  ko: "표",
  fr: "Tableau",
  de: "Tabelle",
  es: "Tabla",
  it: "Tabella",
  pt: "Tabela",
  ru: "Таблица",
)
// caption 用词取自文档语言 text.lang；未覆盖的语种回退到英文。
// 新语种在此补充，即可让 `academic-table` 自动使用对应语言。

#let formats = (
  booktabs: (
    top-stroke: 1.5pt,
    mid-stroke: 0.75pt,
    bottom-stroke: 1.5pt,
    caption-label: (word, nr) => [#word #nr],
    caption-sep: ": ",
    caption-title-transform: (title) => title,
    caption-align: left,
  ),
  apa: (
    top-stroke: 1pt,
    mid-stroke: 1pt,
    bottom-stroke: 1pt,
    caption-label: (word, nr) => text(weight: "bold")[#word #nr],
    caption-sep: "\n",
    caption-title-transform: (title) => emph(title),
    caption-align: left,
  ),
  ieee: (
    top-stroke: 1.5pt,
    mid-stroke: 0.75pt,
    bottom-stroke: 1.5pt,
    caption-label: (word, nr) => upper[#word #numbering("I", nr)],
    caption-sep: "\n",
    caption-title-transform: (title) => upper(title),
    caption-align: center,
  ),
  acs: (
    top-stroke: 1.5pt,
    mid-stroke: 0.75pt,
    bottom-stroke: 1.5pt,
    caption-label: (word, nr) => text(weight: "bold")[#word #nr.],
    caption-sep: " ",
    caption-title-transform: (title) => title,
    caption-align: left,
  ),
  nature: (
    top-stroke: 1.5pt,
    mid-stroke: 0.75pt,
    bottom-stroke: 1.5pt,
    caption-label: (word, nr) => text(weight: "bold")[#word #nr],
    caption-sep: " | ",
    caption-title-transform: (title) => title,
    caption-align: left,
  ),
  elsevier: (
    top-stroke: 1.5pt,
    mid-stroke: 0.75pt,
    bottom-stroke: 1.5pt,
    caption-label: (word, nr) => [#word #nr.],
    caption-sep: " ",
    caption-title-transform: (title) => title,
    caption-align: left,
  ),
  chicago: (
    top-stroke: 1pt,
    mid-stroke: 1pt,
    bottom-stroke: 1pt,
    caption-label: (word, nr) => [#word #nr.],
    caption-sep: " ",
    caption-title-transform: (title) => title,
    caption-align: left,
  ),
  acm: (
    top-stroke: 1.5pt,
    mid-stroke: 0.75pt,
    bottom-stroke: 1.5pt,
    caption-label: (word, nr) => text(weight: "bold")[#word #nr.],
    caption-sep: " ",
    caption-title-transform: (title) => title,
    caption-align: left,
  ),
)

#let _caption-word() = {
  let primary = str(text.lang).split("-").at(0)
  caption-words.at(primary, default: caption-words.en)
}

#let academic-table(
  caption,
  cells,
  format: "apa",
  header: (),
  footer: (),
  label: none,
  ..args
) = {
  let columns = args.named().at("columns", default: 1)
  let preset = formats.at(format)

  set figure.caption(position: top)

  // 表格独立成 kind:table，获得独立编号与本地化的 supplement（表/Table）。
  set figure(kind: table)

  show figure.caption: cap => context {
    set align(preset.caption-align)
    let word = _caption-word()
    let label-content = (preset.caption-label)(word, int(cap.counter.display()))
    let title-content = (preset.caption-title-transform)(cap.body)
    if preset.caption-sep == "\n" {
      label-content
      linebreak()
      title-content
    } else {
      label-content
      preset.caption-sep
      title-content
    }
  }

  [
    #figure(
      table(
        columns: columns,
        ..args,
        stroke: none,
        table.header(
          table.hline(stroke: preset.top-stroke),
          ..header,
          table.hline(stroke: preset.mid-stroke),
        ),
        ..cells,
        if footer != () {
          table.footer(
            table.hline(stroke: preset.bottom-stroke),
            ..footer,
            table.hline(stroke: preset.bottom-stroke),
          )
        } else {
          table.hline(stroke: preset.bottom-stroke)
        },
      ),
      caption: caption,
    ) #label
  ]
}
