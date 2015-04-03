### 1. Counting scenarios
You are given a dataset of phone calls between pairs of people, listing the caller, callee, time of phone call and duration of the phone call (in seconds), a snapshot is given below:

    2125550123    2125559876    Wed Feb 13 19:27:47 EST 2013    123
    6465550123    4155559876    Tue Feb 19 11:35:09 EST 2013    1
    4155550912    2125550123    Mon Apr 9 23:33:59 PST 2012     679
    2125559876    2125550123    Wed Feb 13 19:07:47 EST 2013    509
    ...

Here the first line represents a phone call lasting slightly over two minutes, the second just a quick 1 second call, etc.
Your task is to compute for each pair of phone numbers the total amount of time the parties spent on the phone with each other (regardless of who called whom).

1. Suppose your dataset is the call log of a small town of 100,000 people each of whom calls 50 people on average. Please describe how you would compute the statistics.
#################################################################################
For this, we would do the analysis in-memory on a single machine.  This is ~2.5 million entries, which can be computed locally. Time complexity is O(nm), where n is number of phone calls and m is number of pairs.  (Depending on data structure, we could speed it up to O(n) if we use a hashtable or dictionary as our dataframe.)  I would create a dataframe of pairs: [Caller A, Caller B, total minutes]. Code would look something like:

for item in list:
	if tel1 > tel2:
		temp=tel1
		tel1=tel2
		tel2=temp
	for j in phonelog: 
		if phonelog['tel1'][j]==tel1 and phonelog['tel2'][j]==tel2:
			phonelog['minutes'][j]+=minutes


where
	list= listing of caller (tel1), callee (tel2), and time
	phonelog = dataframe of numbers (first number always smallest value in pair) and minutes
###################################################################################

2. Suppose your dataset is a call log of a large town of 10,000,000 people, each of whom calls 100 people on average. Please describe how you would compute the statistics.
###################################################################################
Because this dataset is substantially bigger, I would do this in streaming or batch data on a single local machine, but I would follow the same approach as above.  The size of the dataset will be the number of possible edges: (10,000,000*100)/2=500 million, which is large but doable locally (around 3-5GB of data).
###################################################################################

3. Suppose the dataset is a call log of a nation of 300,000,000 people, each of whom calls 200 people on average. Please describe how you would compute the statistics.
###################################################################################
This dataset is too large to do on a local machine.  Since the time complexity is at least O(n), this would go too slowly on an single machine.  In addition, the size of the dataset ~ 30 billion entries, which is around 10TB of data. Instead, we could use MapReduce in Spark to run, evaluate, and store the results.  






In writing your descriptions above, you don't need to provide actual working code, but please provide enough detail that someone can easily implement your approach. What differences are there between the three different approaches? Would you use an in-memory or streaming approach? A single machine or multiple machines?



