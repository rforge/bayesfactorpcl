<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
<style type="text/css">.knitr.inline {
  background-color: #f7f7f7;
  border:solid 1px #B0B0B0;
}
.error {
	font-weight: bold;
	color: #FF0000;
}, 
.warning {
	font-weight: bold;
} 
.message {
	font-style: italic;
} 
.source, .output, .warning, .error, .message {
	padding: 0em 1em;
  border:solid 1px #F7F7F7;
}
.source {
  background-color: #f7f7f7;
}
.rimage.left {
  text-align: left;
}
.rimage.right {
  text-align: right;
}
.rimage.center {
  text-align: center;
}

.source {
  color: #333333;
}
.background {
  color: #F7F7F7;
}

.number {
  color: #000000;
}

.functioncall {
  color: #800054;
  font-weight: bolder;
}

.string {
  color: #9999FF;
}

.keyword {
  font-weight: bolder;
  color: black;
}

.argument {
  color: #B04005;
}

.comment {
  color: #2E9957;
}

.roxygencomment {
  color: #707AB3;
}

.formalargs {
  color: #B04005;
}

.eqformalargs {
  color: #B04005;
}

.assignement {
  font-weight: bolder;
  color: #000000;
}

.package {
  color: #96B525;
}

.slot {
  font-style: italic;
}

.symbol {
  color: #000000;
}

.prompt {
  color: #333333;
}
</style>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="/"><img src="<?php echo $themeroot; ?>/images/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
</table>


<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<?php if ($handle=fopen('http://'.$domain.'/export/projtitl.php?group_name='.$group_name,'r')){
$contents = '';
while (!feof($handle)) {
	$contents .= fread($handle, 8192);
}
fclose($handle);
echo $contents; } ?>

<!-- end of project description -->
<h3> Welcome to the development page for BayesFactor.</h3>

<p> The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. </p>





Here we demonstrate a repeated-measures ANOVA-like analysis, using the Bayes factors described in <a href="http://pcl.missouri.edu/node/131">Rouder et al. (2012)</a>. We give a model including the fixed effects we'd like to include (<code>shape</code> and <code>color</code>), and add the effect of participant (<code>ID</code>). We indicate that <code>ID</code> is a random factor with the <code>whichRandom</code> argument. (we turn the progress bars off with <code>progress=FALSE</code> only so they don't show up on the webpage. We recommend leaving them on.)
<div class="chunk"><div class="rcode"><div class="source"><pre class="knitr r"><span class="functioncall">data</span>(puzzles)
bfs = <span class="functioncall">anovaBF</span>(RT ~ shape * color + ID, data = puzzles, whichRandom = <span class="string">"ID"</span>, progress = <span class="keyword">FALSE</span>)
bfs
</pre></div><div class="output"><pre class="knitr r">## Bayes factor analysis
## --------------
## [1] shape + ID                       : 2.819 (1.42%)
## [2] color + ID                       : 2.959 (1.37%)
## [3] shape + color + ID               : 12.01 (1.61%)
## [4] shape + color + shape:color + ID : 4.284 (2.03%)
## ---
##  Denominator:
## Type: BFlinearModel, JZS
## RT ~ ID
</pre></div></div></div>

The model including only the main effects, and no interaction, is preferred by a Bayes factor of about 12 to 1 (with a proportional error in estimation of 1-2%). We can compare the main effect model directly to the main effect plus interaction model, by dividing the two Bayes factors:

<div class="chunk"><div class="rcode"><div class="source"><pre class="knitr r">bfs[3]/bfs[4]
</pre></div><div class="output"><pre class="knitr r">## Bayes factor analysis
## --------------
## [1] shape + color + ID : 2.802 (2.59%)
## ---
##  Denominator:
## Type: BFlinearModel, JZS
## RT ~ shape + color + shape:color + ID
</pre></div></div></div>

The main effects model is preferred over the model with the interaction by a factor of about 2.6 to 1.

We can also sample from the posterior distribution of the model conditioned on the data using the <code>posterior()</code> function:
<div class="chunk"><div class="rcode"><div class="source"><pre class="knitr r">samples = <span class="functioncall">posterior</span>(bfs[4], iterations = 10000)
</pre></div></div></div>

This samples from the posterior of the fourth numerator model in <code>bfs</code>, which is the model with interaction. <code>samples</samples> now contains the Gibbs sampler output:
<div class="chunk"><div class="rcode"><div class="source"><pre class="knitr r"><span class="functioncall">summary</span>(samples[, <span class="functioncall">c</span>(1:5, 18:21)])
</pre></div><div class="output"><pre class="knitr r">## 
## Iterations = 1:10000
## Thinning interval = 1 
## Number of chains = 1 
## Sample size per chain = 10000 
## 
## 1. Empirical mean and standard deviation for each variable,
##    plus standard error of the mean:
## 
##                                       Mean    SD Naive SE Time-series SE
## mu                                 44.9956 0.697  0.00697        0.00764
## shape-round                         0.4288 0.189  0.00189        0.00218
## shape-square                       -0.4288 0.189  0.00189        0.00218
## color-color                        -0.4254 0.191  0.00191        0.00200
## color-monochromatic                 0.4254 0.191  0.00191        0.00200
## shape:color-round.&.color          -0.0014 0.165  0.00165        0.00159
## shape:color-round.&.monochromatic   0.0014 0.165  0.00165        0.00159
## shape:color-square.&.color          0.0014 0.165  0.00165        0.00159
## shape:color-square.&.monochromatic -0.0014 0.165  0.00165        0.00159
## 
## 2. Quantiles for each variable:
## 
##                                       2.5%    25%      50%    75%   97.5%
## mu                                 43.5646 44.565 44.99857 45.434 46.3690
## shape-round                         0.0648  0.301  0.42639  0.555  0.8003
## shape-square                       -0.8003 -0.555 -0.42639 -0.301 -0.0648
## color-color                        -0.8115 -0.550 -0.42360 -0.297 -0.0607
## color-monochromatic                 0.0607  0.297  0.42360  0.550  0.8115
## shape:color-round.&.color          -0.3276 -0.106 -0.00214  0.105  0.3242
## shape:color-round.&.monochromatic  -0.3242 -0.105  0.00214  0.106  0.3276
## shape:color-square.&.color         -0.3242 -0.105  0.00214  0.106  0.3276
## shape:color-square.&.monochromatic -0.3276 -0.106 -0.00214  0.105  0.3242
</pre></div></div></div>

We can plot the posterior distribution of the difference between the two shape main effect factor levels:
<div class="chunk"><div class="rcode"><div class="source"><pre class="knitr r"><span class="functioncall">plot</span>(samples[, <span class="string">"shape-round"</span>] - samples[, <span class="string">"shape-square"</span>])
</pre></div></div><div class="rimage default"><img src="figure/unnamed-chunk-6.png"  class="plot" /></div></div>

The effect is about 1.

</body>
</html>


