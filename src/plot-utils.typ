#import "@preview/cetz:0.3.4"

// colours from the TikZ preamble
#let curveblue = rgb("#2F6FDB")
#let tanred = rgb("#E4572E")
#let tealone = rgb("#2A9D8F")
// xcolor `violet` is (0.5, 0, 0.5); Typst's built-in `purple` is a different colour
#let violet = rgb("#800080")
// xcolor mixes with white: gray = 50%, gray!60 -> 70%, gray!30 -> 85%, black!70 -> 30%, black!60 -> 40%
#let gray50 = luma(50%)
#let gray70 = luma(70%)
#let gray85 = luma(85%)
#let black30 = luma(30%)
#let black40 = luma(40%)

// font sizes used for TikZ \scriptsize, \footnotesize, \small, \normalsize, \large
#let fs-script = 8pt
#let fs-foot = 9pt
#let fs-small = 10pt
#let fs-norm = 11pt
#let fs-large = 12pt

// coloured text, like \rc and \tc in LaTeX
#let rc(body) = text(fill: tanred, body)
#let tc(body) = text(fill: tealone, body)

// TikZ `dotted` (on = line width, off = 2pt) and `dashed` (3pt on, 3pt off)
#let tikz-dotted(c, w: 0.8pt) = (paint: c, thickness: w, dash: (w, 2pt))
#let tikz-dashed(c, w: 0.8pt) = (paint: c, thickness: w, dash: (3pt, 3pt))

// number -> content, without trailing ".0" and without float noise
#let fmt(v) = {
  let r = if v == calc.floor(v) { int(v) } else { calc.round(v, digits: 2) }
  [#r]
}

// A pgfplots-like axis box. `draw` is called as draw(p, pt):
//   p(x, y)  maps data coordinates to canvas coordinates
//   pt(len)  converts a length (e.g. 3pt) to canvas units
#let graph(xmin, xmax, ymin, ymax, width, height, draw, padding: 2mm) = {
  let unit = width / (xmax - xmin)
  let k = (height / width) * (xmax - xmin) / (ymax - ymin)
  cetz.canvas(length: unit, padding: padding / unit, {
    import cetz.draw: *
    let p = (x, y) => (x - xmin, (y - ymin) * k)
    let pt = v => v / unit
    draw(p, pt)
  })
}

// axis lines (through the origin) with arrows, ticks and tick labels.
// A tick is either a number or a (value, label-content) pair.
#let axes(
  p, pt, xmin, xmax, ymin, ymax,
  xticks: (), yticks: (),
  font-size: 10pt, x-font-size: none,
  arrow-length: 2.5mm, tick-half: 1mm,
  xlabel: none, ylabel: none, label-size: 11pt,
  xlabel-anchor: "south-east", ylabel-anchor: "north-west",
  yticks-right: false,
) = {
  import cetz.draw: *
  let arrow = (end: "stealth", length: arrow-length, fill: black)
  let half = pt(tick-half)
  let xfs = if x-font-size == none { font-size } else { x-font-size }
  line(p(xmin, 0), p(xmax, 0), stroke: black + 0.8pt, mark: arrow)
  line(p(0, ymin), p(0, ymax), stroke: black + 0.8pt, mark: arrow)
  for t in xticks {
    let (v, lab) = if type(t) == array { t } else { (t, fmt(t)) }
    let (cx, cy) = p(v, 0)
    line((cx, cy - half), (cx, cy + half), stroke: black + 0.5pt)
    content((cx, cy - half - pt(2pt)), text(size: xfs)[#lab], anchor: "north")
  }
  for t in yticks {
    let (v, lab) = if type(t) == array { t } else { (t, fmt(t)) }
    let (cx, cy) = p(0, v)
    line((cx - half, cy), (cx + half, cy), stroke: black + 0.5pt)
    if yticks-right {
      content((cx + half + pt(2pt), cy), text(size: font-size)[#lab], anchor: "west")
    } else {
      content((cx - half - pt(2pt), cy), text(size: font-size)[#lab], anchor: "east")
    }
  }
  if xlabel != none {
    content(p(xmax, 0), text(size: label-size)[#xlabel], anchor: xlabel-anchor, padding: pt(2pt))
  }
  if ylabel != none {
    content(p(0, ymax), text(size: label-size)[#ylabel], anchor: ylabel-anchor, padding: pt(2pt))
  }
}

// grid lines at the given tick values (draw BEFORE the axes)
#let grid-lines(p, xmin, xmax, ymin, ymax, xs, ys, grid-stroke: gray85 + 1pt) = {
  import cetz.draw: *
  for x in xs { line(p(x, ymin), p(x, ymax), stroke: grid-stroke) }
  for y in ys { line(p(xmin, y), p(xmax, y), stroke: grid-stroke) }
}

// a function plotted as one polyline
#let plot-curve(
  p, f, start, end,
  samples: 160,
  style: (paint: curveblue, thickness: 2pt, cap: "round", join: "round"),
) = {
  import cetz.draw: *
  let points = range(0, samples + 1).map(i => {
    let x = start + i / samples * (end - start)
    p(x, f(x))
  })
  line(..points, stroke: style)
}

// pgfplots `mark=*` (draw = colour, fill = colour or colour!20)
#let marker(p, x, y, color, r: 3pt, light: false) = {
  import cetz.draw: *
  circle(
    p(x, y), radius: r,
    fill: if light { color.lighten(80%) } else { color },
    stroke: color + 0.4pt,
  )
}
