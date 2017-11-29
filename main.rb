require './halstead_metric'

$metric = HalsteadMetric.new(File.open("./code.rb").read)
$metric.show
