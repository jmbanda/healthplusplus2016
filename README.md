# Health++ 2016 - Deep Pill Finder

## Inspiration

More Americans than ever take prescription pills and take more of them. Almost 60% of adults took prescription pills in 2012, up from 50% in 2000. And 15% of adults took 5 or more prescription pills in 2012, up from 10% in 2000. Trends in prescription pill use showed increases for statins, antidepressants, and to treat high blood pressure. (Kantor ED, Rehm CD, Haas JS, Chan AT, Giovannucci EL. Trends in Prescription Drug Use Among Adults in the United States From 1999-2012. JAMA. 2015 Nov 3;314(17):1818-31. doi: 10.1001/jama.2015.13766. PubMed PMID: 26529160; PubMed Central PMCID: PMC4752169.)

Americans' increase in pill use and the challenges of managing that use are also seen in the 44% increase in calls to U.S. poison control centers from 2003 to 2007, with the majority of that increase traced to questions about "pill identification." Calls from the public and the police doubled in that time period, while calls from healthcare facilities decreased, highlighting the need for a tool that the public can use to identify pills. (Spiller HA, Griffith JR. Increasing burden of pill identification requests to US Poison Centers. Clin Toxicol (Phila). 2009 Mar;47(3):253-5. doi:10.1080/15563650902754877. PubMed PMID: 19225960.)

The pharmaceutical industry has responded to the increased use and cost of prescription pills by offering both brand-name and often cheaper generic pills. Generic pills now make up 70% of the total number of U.S. pill prescriptions. The choices multiply from there, with each generic pill manufacturer selling a pharmacologically equivalent pill in a different shape, color, and size. (Greene JA, Kesselheim AS. Why do the same drugs look different? Pills, trade dress, and public health. N Engl J Med. 2011 Jul 7;365(1):83-9. doi:10.1056/NEJMhle1101722. PubMed PMID: 21732842.)

Not having time to submit to the actual challenge posted by the NIH (https://www.nlm.nih.gov/news/nlm-pill-image-challenge-2016.html), we wanted to contribute by taking a stab at this very important problem. We wanted to build an API that would allow any other app, hospital, etc, to use our model for pill classification.

## What it does

This proof of concept deep learning model shows that it is possible to train a neural net and predict what kind of pill image is being presented by the user. We reached classification accuracies of under 80% on our simple test model (10 classes 140 images).

## How we built it

We used the NIH test datasets for their pill recognition challenge (https://pir.nlm.nih.gov/challenge/submission.html) but in a very different way. We grouped pills by NDC number and trained with both the consumer and professional grade images. Due to the limited computer resources we had for the hackathon, we created a smaller subset for our feasibility analysis of 10 different pills and 140 images total. 

## Challenges we ran into

Training neural networks is very very expensive... particularly on a Mac book. Also, using high resolution images adds to the complexity.

## Accomplishments that we're proud of

We managed to train a baseline model that at-best produces 80% classification accuracy for 10 different classes. Using a 80% training, 20% testing environment.

## What we learned

How to build Deep Learning models in R.

## What's next for PillFinder

Train on a bigger machine using our full training set derived from the NIH challenge set. This set is also included under our github repo zipped and already prepped to feed into the model building script. This took over 2 hours for one epoch in our laptop.... so we need a server for this. Provide a pretty UI for submission, but the main idea is to provide an API to do this.

## Tech Stack:

Proof of concept model built with R, mxnet and imager packages
