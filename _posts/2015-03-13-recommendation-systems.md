---
layout: post
title:  "Lecture 8: Recommendation Systems"
date:   2015-03-13 12:00:00
categories: lectures
---

We began this lecture with a look at metrics for evaluating classification algorithms.
While loss functions give us a way of finding best-fit parameters for a model, there are often more direct measures of model performance that we care about: maximizing accuracy, minimizing a false positive ()or false negative) rate, or being properly calibrated.

In particular, we looked at the [Receiver Operator Characteristic (ROC)](http://en.wikipedia.org/wiki/Receiver_operating_characteristic#Area_under_curve) curve for assessing how a classifier's performance changes as we change its sensitivity or specificity.
The area under the ROC curve (AUC) summarizes this tradeoff in a simple and interpretable way: what's the probability that a classifier can correctly distinguish between one randomly chosen positive example and one randomly chosen negative one?
This is a particularly nice metric in contrast to something like accuracy in that it isn't sensitive to class imbalance (i.e., having many more positive examples than negatives).
See Fawcett's [introduction to ROC analysis](https://ccrma.stanford.edu/workshops/mir2009/references/ROCintro.pdf) as well as this [interactive ROC demo](http://www.navan.name/roc/) for more.
Source code comparing ROC curves for the performance of naive Bayes and logistic regression in detecting spam is on the [Rpubs](http://rpubs.com/jhofman/nb_vs_lr) and the [course GitHub page](https://github.com/jhofman/msd2015/tree/master/lectures/lecture_8).

<center>
<iframe src="//www.slideshare.net/slideshow/embed_code/46591272" width="476" height="400" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</center>

In the second half of class we discussed collaborative filtering, a method that exploits historical patterns in user activity to infer user preferences and make recommendations.
Collaborative filtering methods generally belong to one of two categories: memory-based, such as k-nearest neighbors, and model-based, such as matrix factorization.

Memory-based methods use past activity to compute similarities between users (e.g., how many items have we both liked or rated similarly?).
Recommendations for a given user are then made by looking for popular items amongst their most similar "neighbors".

Model-based methods, in contrast, represent users and items as points in an abstract space of latent preferences / attributes.
The model is fit so that users are "near" items in this space that they have rated highly in the past, and recommendations are generated by looking for other nearby items that the user has not yet consumed.


See this [overview of Amazon's early recommender](http://www.cs.umd.edu/~samir/498/Amazon-Recommendations.pdf) and chapter 2 of [Programming Collective Intelligence](http://shop.oreilly.com/product/9780596529321.do) for more information on k-nearest neighbor recommendations and Koren & Volinksy's [paper on matrix factorization](http://www2.research.att.com/~volinsky/papers/ieeecomputer.pdf) for more details.
Additional references are in the slides.
