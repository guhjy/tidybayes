# A stat_summaryh with a geom_intervalh
#
# Author: mjskay
###############################################################################


#' @rdname stat_interval
#' @export
stat_intervalh <- function(mapping = NULL, data = NULL,
  geom = "intervalh", position = "identity",
  ...,
  point.interval = mean_qih,
  fun.data = point.interval,
  .prob = c(.95, .8, .5),
  fun.args = list(),
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  # Probs are drawn on top of each other in order by geom_intervalh, so we have to sort in decreasing order
  # to make sure the largest interval is not drawn last (over-writing all other intervals)
  .prob %<>% sort(decreasing = TRUE)

  l = layer(
    data = data,
    mapping = mapping,
    #we can re-use StatPointintervalh internally because it does exactly the same thing
    #we would have done for a StatIntervalh.
    stat = StatPointintervalh,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      fun.data = fun.data,
      .prob = .prob,
      fun.args = fun.args,
      na.rm = na.rm,
      ...
    )
  )

  #provide some default computed aesthetics
  default_computed_aesthetics = aes(color = forcats::fct_rev(ordered(...prob..)))  # nolint

  compute_aesthetics = l$compute_aesthetics
  l$compute_aesthetics = function(self, data, plot) {
    apply_default_computed_aesthetics(self, plot, default_computed_aesthetics)
    compute_aesthetics(data, plot)
  }

  map_statistic = l$map_statistic
  l$map_statistic = function(self, data, plot) {
    apply_default_computed_aesthetics(self, plot, default_computed_aesthetics)
    map_statistic(data, plot)
  }

  l
}
