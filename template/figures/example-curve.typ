#import "@preview/shine-notes:0.1.0": axes, curveblue, graph, plot-curve

#let example-curve = graph(
  -2, 2, -0.5, 4.5, 8cm, 5cm,
  (p, pt) => {
    axes(
      p, pt, -2, 2, -0.5, 4.5,
      xticks: (-2, -1, 0, 1, 2),
      yticks: (1, 2, 3, 4),
      font-size: 9pt,
      xlabel: $x$,
      ylabel: $y$,
    )
    plot-curve(p, x => x * x, -2, 2, style: (paint: curveblue, thickness: 2pt))
  },
)
