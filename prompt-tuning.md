# Contents

* [Tuning a model with Prompt Tuning](#tuning-a-model-with-prompt-tuning)
* [Running inference on a tuned model](#running-inference-on-a-tuned-model)

# Tuning a model with Prompt Tuning

We aim to fine-tune a Large Language Model (LLM) to effectively classify
specific text. Although LLMs excel at generating coherent and
contextually relevant text, they do not inherently comprehend subjects;
they merely predict logical continuations based on patterns in the data
they were trained on. For instance, they might suggest a department to
manage a customer complaint without genuine understanding of the issue's
nature. To address this, we will instruct the model using examples, a
process known as prompt tuning. This involves providing the model with
representative samples to guide its responses and enhance its
subject-matter understanding.

To accomplish our goal, we will employ a carefully curated training
dataset. This set comprises diverse examples that represent various
scenarios and contexts relevant to our classification task. By training
on this dataset, the LLM will learn to better understand the subject
matter and improve its ability to classify text accurately.

We refer to this data as “labelled Data” where we associate the correct
output to the given input. See an example below.

```
{
  "input" : "This is so flimsy! It can't support my weight.",
  "output" : "Planning, Development"
}
```

Copy the following data in a text file named **complaints.jsonl** on
your machine.

```
{"input":"I can't find any instructions in English.","output":"Packaging"}
{"input":"I am missing some of the parts.","output":"Warehouse, Packaging"}
{"input":"There is no instruction on how to assemble the foundation.","output":"Packaging"}
{"input":"The product is not working out-of-box.","output":"Development"}
{"input":"Your product broke after 2 weeks of usage!","output":"Service, Development"}
{"input":"This product does not work as advertised!","output":"Marketing, Development"}
{"input":"Some of the parts are scratched up even though the package looks to be new.","output":"Packaging"}
{"input":"The top speed I get is much lower than what you say in your marketing material.","output":"Development, Marketing"}
{"input":"This does not look anything like what you have on your website.","output":"Planning, Marketing"}
{"input":"This does not do the job, it's just not the right tool as your brochure suggested","output":"Planning, Development, Marketing"}
{"input":"You shipped me a product that requires 220 V and it does not work here in Canada!","output":"Planning, Packaging"}
{"input":"The resolution of your projector is so bad, totally useless.","output":"Planning, Development"}
{"input":"The joints shipped with the product break easily, and now I can't assemble it.","output":"Planning, Service, Development"}
{"input":"Why does your advertisement show a royal blue unit but you shipped me a red one?","output":"Packaging, Marketing"}
{"input":"This is so flimsy! It can't support my weight.","output":"Planning, Development"}
{"input":"Your product is useless. I used double of the recommended portion and still it can't clean properly.","output":"Planning, Development"}
{"input":"My laundry still stinks after washing with your product.","output":"Development"}
{"input":"The LED display is so faint, I can't read it at all.","output":"Planning, Development"}
{"input":"I can't insert the memory card, it just won't hold it.","output":"Planning, Development"}
{"input":"I was given the impression that the 5-speed version is out, but I don't see anything from your catalogue","output":"Planning, Marketing"}
{"input":"OK, when you say multi-language, you just mean English and French. It's misleading and we need more - German, Spanish, Japanese to start","output":"Planning, Marketing"}
{"input":"I am surprised that you actually don't have domain-specific models - you talk about the importance of that all the time.","output":"Planning, Marketing"}
{"input":"Why do you keep talking about the importance of a vector database but you don't offer one!","output":"Planning, Marketing"}
{"input":"The drawers are too wide, you need internal dividers for it to be practical.","output":"Planning, Development"}
{"input":"I see you listed 5 models on your poster, but none of your dealerships have all of them.","output":"Planning, Marketing"}
{"input":"In your online call we were told that your platform can do summarization, but it is not listed in your actual product.","output":"Planning, Marketing"}
{"input":"Your product page mentions Amazon Web Services all the time, but your product is not available from Amazon's marketplace?","output":"Planning, Marketing"}
{"input":"Why are you talking about prompt tuning all the time when it is not available from your product?","output":"Planning, Marketing"}
{"input":"I cannot find the red model on your catalogue - that was so prominent in your posters.","output":"Planning, Marketing"}
{"input":"The suction cup you provided is totally useless, won't attach to my windshield at all!","output":"Planning, Development"}
{"input":"There are no tools that came with the box? How can I assemble the product?","output":"Planning, Packaging"}
{"input":"There are multiple missing parts from the package.","output":"Warehouse, Packaging"}
{"input":"It is much shorter than I saw from your commercials.","output":"Planning, Marketing"}
{"input":"Why can't this product cut through concrete?","output":"Planning, Development"}
{"input":"The engine gets too hot when we run it.","output":"Planning, Development"}
{"input":"I bought the top of the line but it is out-performed by my old model","output":"Planning, Development"}
{"input":"Why does the battery have such a short lifespan?","output":"Planning, Development"}
{"input":"The wheels on this bike do not align properly.","output":"Planning, Development"}
{"input":"The pattern on the side is crooked.","output":"Planning, Development"}
{"input":"Why does this have a nasty diesel smell?","output":"Planning, Development"}
{"input":"I don't like the sound it makes when it runs.","output":"Planning, Development"}
{"input":"Where is my warranty card? can't find it in the box.","output":"Packaging"}
{"input":"This thing just does not perform.","output":"Planning, Development"}
{"input":"There are not enough screws available to assemble the product.","output":"Warehouse, Packaging"}
{"input":"I just bought it today but half the oranges in the box are rotten!","output":"Planning, Warehouse"}
{"input":"I was put on hold for 30 minutes!","output":"Service"}
{"input":"I am so sick of hearing the elevator music waiting for someone to come online.","output":"Service"}
{"input":"I was put on hold for 50 minutes!","output":"Service"}
{"input":"I called 10 times and every time there is a robot at the other end!","output":"Service"}
{"input":"I am returning the product because I waited 50 minutes and got no response.","output":"Service"}
{"input":"I don't have time to wait on your long queue.","output":"Service"}
{"input":"What do you mean you don't have it anymore?  My cousin just bought one last week!","output":"Warehouse, Planning"}
{"input":"Why can't I order this anymore?","output":"Warehouse, Planning"}
{"input":"I ordered 5 units and you shipped me only 2, where is the rest?","output":"Warehouse, Packaging"}
{"input":"The shipment is supposed to have 6 units it in, but there were only 5","output":"Warehouse, Packaging"}
{"input":"The Kron model you shipped me is missing 2 drawer handles!","output":"Warehouse, Packaging"}
{"input":"I ordered a set of screwdriver bits, but there is no Robersons's in the lot.","output":"Warehouse, Packaging"}
{"input":"I looked all over the box, but the user guide and the jig are missing.","output":"Warehouse, Packaging"}
{"input":"You sent me the camera but there is no HD card that is shown on the box.","output":"Warehouse, Packaging"}
{"input":"I can't find the mouth guard to the hockey set. It is useless without it.","output":"Warehouse, Packaging"}
{"input":"Where is the fourth bedpost? It is not in the box.","output":"Warehouse, Packaging"}
{"input":"Where are the 2 extra sets of sheets that are supposed to come with my order?","output":"Warehouse, Packaging"}
{"input":"The assembly kit is missing the 6-in screws. It can't be used without them.","output":"Warehouse, Packaging"}
{"input":"How come this item is grayed out for the whole month?","output":"Warehouse, Planning"}
{"input":"It's the fifth time I called and you still don't have this item.","output":"Warehouse, Planning"}
{"input":"I need this brand because I am allergic to your other ones!","output":"Warehouse, Planning"}
{"input":"Come on, 4 weeks and you are still out of stock?","output":"Warehouse, Planning"}
{"input":"What is wrong with your inventory system? How can this be still out of stock?","output":"Warehouse, Planning"}
{"input":"What do you mean I can no longer get parts for this item?","output":"Warehouse, Planning"}
{"input":"I have been using this for years, we depend on it, why is it no longer available?","output":"Warehouse, Planning"}
{"input":"How come I can no longer order this model number?","output":"Warehouse, Planning"}
{"input":"You must be crazy to discontinue this most popular model from your product line.","output":"Warehouse, Marketing, Planning"}
{"input":"I called your rep and was told this is out of stock, why?","output":"Warehouse, Planning"}
{"input":"I went to all your retail stores and still can't find this part!","output":"Warehouse, Planning"}
{"input":"I ordered this piece online but it has not arrived after 3 weeks!","output":"Warehouse, Packaging"}
{"input":"Your catalogue says it is available in yellow, so why can't I order it in yellow?","output":"Warehouse, Planning, Marketing"}
{"input":"I don't want a refund, I want my purchased item!","output":"Warehouse, Packaging"}
{"input":"Come on, you said it will be available in 4 months,  it is now 9 months.","output":"Warehouse, Packaging"}
{"input":"I give up, I am going to another store as you just never have this item.","output":"Warehouse, Planning"}
{"input":"This is listed on your flyers, the sale starts today, so how can you not have this item?","output":"Warehouse, Planning"}
{"input":"This is nuts, every time you transfer me to a different agent I have to tell them everything from scratch","output":"Service"}
{"input":"Look, get me the person who can fix this, I refuse to repeat my issues to people who can't fix my problem.","output":"Service"}
{"input":"I NEED assistance when I call, I don't want to just waste time repeating myself!","output":"Service"}
{"input":"Why do I need to describe my issues like 3 times in a single call?","output":"Service"}
{"input":"Why are you asking me this again? Didn't the last person write all of it down?","output":"Service"}
{"input":"Your product does not work, how many times do I have to say it?","output":"Service, Development"}
{"input":"Forget it, clearly none of you know how to fix this.","output":"Service, L3"}
{"input":"Yes, I tried all those steps already, twice now!","output":"Service"}
{"input":"Your service team clearly does not have the skills to solve the simplest problems.","output":"Service, L3"}
{"input":"I was told I was talking to an SME, but clearly it was not the case.","output":"Service, L3"}
{"input":"I have enterprise-level support, and my dedicated service contact can't solve anything!","output":"Service, L3"}
{"input":"Your rep told me what the cause was, and it was completely wrong!","output":"Service, L3"}
{"input":"Well, the email I got with all the instructions, none of it work!","output":"Service, L3"}
{"input":"Who do I have to talk to so I can get help? Your L3 support is useless.","output":"Service, L3"}
{"input":"This is a level 3 support? I can read off a list just as well","output":"Service, L3"}
{"input":"I was on the phone with your 'expert' for 3 hours and nothing was solved","output":"Service, L3"}
{"input":"This is madness, I followed your steps and now the device is completely broken","output":"Service, L3"}
{"input":"None of the steps you suggested work, in fact, it made it worse","output":"Service, L3"}
{"input":"You are kidding, you want me to try to reproduce the steps?","output":"Service, L3"}
{"input":"You keep transferring me to a different agent, and every time I have to repeat myself with no actual help provided!","output":"Service, L3"}
{"input":"I already sent you all the details in an email, so why are you asking me for the same info?","output":"Service"}
{"input":"I am filing a complaint, your rep just don't seem to care or know anything useful.","output":"Service, L3"}
{"input":"How can your service rep hang up on me?","output":"Service"}
{"input":"Why do I have to call 3 times just to get your rep to open a case file?","output":"Service"}
{"input":"You need to hire people who are willing to listen to your customer!","output":"Service"}
{"input":"Why do I have to repeat myself over and over again? Was your service rep not listening?","output":"Service"}
{"input":"It is good to have a Return to main menu button.","output":"Planning, Development"}
{"input":"Need support for 64-bit OS.","output":"Planning, Development"}
{"input":"When will you support a MacOS version?","output":"Planning, Development"}
{"input":"This product is good but is missing good logging capabilities.","output":"Planning, Development"}
{"input":"We need a 2 phase commit capability for our use case.","output":"Planning, Development"}
{"input":"When we define a pointer, the IDE needs to use a different pen color.","output":"Development"}
{"input":"We need a way to track the list of downloaded files.","output":"Development"}
{"input":"It would be great to have a screen capture capability.","output":"Development"}
{"input":"From your JSON content panel, it would be good to launch a visualizer for the content.","output":"Planning, Development"}
{"input":"Please support AVRO in addition to Parquet format.","output":"Planning, Development"}
{"input":"It's difficult to understand why you don't have this in blue!","output":"Planning"}
{"input":"The fridge door should be configurable to be opened in either direction.","output":"Planning, Development"}
{"input":"We need domain-specific foundation models, especially for cybersecurity.","output":"Planning"}
{"input":"I looked for the ability to track file lineage but I don't think you support it.","output":"Planning, Development, L3"}
{"input":"You need to include an extension pole in your package. It's too short as it is.","output":"Planning, Packaging"}
{"input":"We like to see a V8 version of your latest product.","output":"Planning"}
{"input":"We are looking for these tools in metric, not just in feet and inches.","output":"Planning"}
{"input":"Do you not have side bags available in your travel section?","output":"Planning"}
{"input":"You need to carry eco-friendly product in your retail stores.","output":"Planning, Marketing"}
{"input":"There are no books in your store on healthy diet.","output":"Planning"}
{"input":"In addition to soil and mulch, we were also looking for peat moss.","output":"Planning"}
{"input":"No, we didn't find everything we were looking for, you don't have smoke alarms.","output":"Planning"}
{"input":"There are no 1.5 inch Robertson screws on your shelves.","output":"Planning, Warehouse"}
{"input":"Can I get this drill with a longer snout?","output":"Planning"}
{"input":"I can't believe you don't sell green peppers here in your store.","output":"Planning"}
{"input":"I think it's a great idea if you add a tinted roof to your cars.","output":"Planning"}
{"input":"Why do you not have all-wheel-drive?","output":"Planning, Development"}
{"input":"You should put in new seat cushions to make it more comfortable for your riders.","output":"Planning"}
{"input":"You need to put in a vegetarian section in your menu.","output":"Planning, Marketing"}
{"input":"We need the following features to be added to your next release.","output":"Planning, Development"}
{"input":"Can you create a new drone with a single rotary engine?","output":"Planning, Development"}
{"input":"We need your drone to have a longer range � add at least 50 km.","output":"Planning, Development"}
{"input":"Can you put a smaller camera on your drone?","output":"Planning"}
{"input":"Your screen needs to be bigger and of better quality.","output":"Planning, Development"}
{"input":"Why is there no backup camera?  Everyone has it.","output":"Planning"}
{"input":"When will you come up with a front wheel drive version?","output":"Planning, Marketing, Development"}
{"input":"Your coffee is good but would be better if you have a decaffeinated product.","output":"Planning, Marketing"}
{"input":"Perhaps a bigger window would be better.","output":"Planning"}
{"input":"You need to add a quiz to make this a better course.","output":"Planning"}
{"input":"How come there is no size ten Robertson in your screwdriver bit set?","output":"Planning, Warehouse"}
{"input":"Add a light to your drill?","output":"Planning"}
{"input":"I called your support center 3 times before getting any help.","output":"Service, L3"}
{"input":"Your first line support staff has no knowledge at all and it was a waste talking to them.","output":"Service, L3"}
{"input":"You need to hire better level 1 staff. I had to escalate to your level 3 to get help.","output":"Service"}
{"input":"I did everything your staff told me to do, and everything is still broken.","output":"Service, L3"}
{"input":"I called and your staff said they will rectify it. It's a week now and I still have no access to my account","output":"Service"}
{"input":"I was told a replacement will be sent, well nothing has arrived.","output":"Service, Packaging"}
{"input":"I followed the instructions given to me to try to get it resolved, but the steps don't work.","output":"Service, L3"}
{"input":"Why can't your first line support staff route me to the expert?  Why do they always have to call back?","output":"Service, L3"}
{"input":"I can never get any useful help with the first call.","output":"Service, L3"}
{"input":"You know, only your level 3 has any skills, the others are useless.","output":"Service, L3"}
{"input":"Your first line support always goes through the same checklist before sending me to people who can actually help.","output":"Service, L3"}
{"input":"Perhaps it would help if your first line support knows about the product instead of having to go get experts every time.","output":"Service, L3"}
{"input":"I give up on calling your team. I always get more info with Google.","output":"Service, L3"}
{"input":"Why can't you provide better training so your first line staff can actually answer questions?","output":"Service, L3"}
{"input":"Look, I know how to find your documentation, telling me to check is pointless.","output":"Service"}
{"input":"I never get useful feedback, suggestion, or resolution on a first call with you.","output":"Service"}
{"input":"Your store staff gave me suggestions that are totally wrong, not even applicable to my model!","output":"Service, L3"}
{"input":"I went back to your store and they told me to call 3 different numbers to get help!","output":"Service"}
{"input":"You need this 2-phase commit feature in your product","output":"Planning, Development"}
{"input":"How come your device does not perform an auto-reboot after an update?","output":"Planning, Development"}
{"input":"You must be scalable to be enterprise-ready. It is not useable as it is.","output":"Planning, Development"}
{"input":"All other companies provide automation, you are still behind.","output":"Planning, Development"}
{"input":"I cannot believe that your product is only available in AWS and not Azure.","output":"Planning, Development"}
{"input":"Your largest size still does not provide enough resources for real enterprise workload.","output":"Planning, Development"}
{"input":"You need variable speed. No one can live with just hi-med-low","output":"Planning, Development"}
{"input":"The X-frame you provide is not strong enough - it needs to be at least 3 inches across instead of 2.","output":"Planning, Development"}
{"input":"Your console needs to remember the history of previous steps. It is unacceptable to have to type things in for every run.","output":"Planning, Development"}
{"input":"You need a left-handed version for your scissors.","output":"Planning, Development"}
{"input":"This is a bug in your code. It should never do this","output":"Development, Service"}
{"input":"Your customer service should be called customer-router! They don't know anything and can't resolve anything.","output":"Service, L3"}
{"input":"I had to call 3 times, talked to 5 persons before getting this resolved.","output":"Service, L3"}
{"input":"I've been waiting 3 days for your SME to call back.","output":"Service, L3"}
{"input":"Hello anyone actually checking what you are supposed to do to follow up?","output":"Service"}
{"input":"I am going to your competitor, you never called me back.","output":"Service"}
{"input":"When are you going to send me my reactivation code?","output":"Service"}
{"input":"I wonder if you care for new business at all? I left my e-info and no one has contacted us.","output":"Service, Planning"}
{"input":"Well it's been 3 days, who is supposed to call me to resolve this issue?","output":"Service, L3"}
{"input":"Where is the replacement that I was promised?","output":"Service, L3"}
{"input":"Your service guy never showed up.","output":"Service"}
{"input":"Your staff did not bring a receipt and told me it would be dropped off in mail, that was 2 weeks ago.","output":"Service, L3"}
{"input":"Look, don't ask me to leave you my number if you never intend to call back.","output":"Service, L3"}
{"input":"Your shelves for oil are completely empty.","output":"Warehouse"}
{"input":"You advertised a chainsaw for 100 dollars, but on your shelves, I see only the 200 variant.","output":"Warehouse, Marketing"}
{"input":"There is no more generator in your store.","output":"Warehouse"}
{"input":"You have trip-A and 9V batteries, but there is no AA size?","output":"Warehouse"}
{"input":"I am looking for no-sugar beverages but you don't have any","output":"Warehouse, Planning"}
{"input":"Why is there no aspirin from your pharmacy section?","output":"Warehouse, Planning"}
{"input":"How is it possible that you ship me 2 left shoes in my order?","output":"Packaging"}
{"input":"I asked for yellow markers, you shipped me red!!!","output":"Packaging"}
{"input":"I did not order 5 pairs of shorts, only 2.","output":"Packaging"}
{"input":"You sent me a table set with 4 chairs - but your brochure has 6","output":"Packaging, Marketing"}
{"input":"The unit I received was all damaged. I want a refund","output":"Packaging, Service"}
{"input":"I am missing 2 drawer handles from your last shipment.","output":"Packaging"}
```

Now return to your project page and click on Import Asset.

<img src="./media/image26.jpeg"
style="width:6.26806in;height:3.34861in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

Choose to import a local file as a Data Asset

<img src="./media/image27.jpeg"
style="width:6.26806in;height:3.90208in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

Upload the complaints.jsonl file

<img src="./media/image28.jpeg"
style="width:6.26806in;height:3.93333in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

Prior to initiating the tuning experiment, it's essential to establish
task credentials for enhanced security. These credentials are necessary
to execute a Tuning Studio experiment. To do so, generate a user API
key, which serves as authentication for runtime operations within IBM
watsonx.ai, including prompt tuning.

Access your user profile by clicking on your user icon on the upper
right

<img src="./media/image29.jpeg"
style="width:6.26806in;height:3.8875in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

And create a User API Key.

<img src="./media/image30.jpeg"
style="width:6.26806in;height:3.77153in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

You can now return to your project and add a new asset.

<img src="./media/image31.jpeg"
style="width:6.26806in;height:3.87917in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

We want to add a new model asset via Prompt Tuning. Therefore, we will
choose **work with Models** and choose to **Tune a foundation model with
labelled data**.

<img src="./media/image32.jpeg"
style="width:6.26806in;height:3.88125in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

We will fine tune the **flan-t5-xl-3b model** so let’s input the
following information in the popup window.

<img src="./media/image33.jpeg"
style="width:6.26806in;height:3.88472in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

We need to choose the model to fine tune now.

<img src="./media/image34.jpeg"
style="width:6.26806in;height:3.8375in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

<img src="./media/image35.jpeg"
style="width:6.26806in;height:3.85694in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

The Model card will show up and allow us to review the model
documentation before confirming that we want to use that model.

<img src="./media/image36.jpeg"
style="width:6.26806in;height:4.09375in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

We are now ready to setup the tuning experiment.

First, we will initialize the prompt with the following text

```
Classify the following complaint and determine which departments to
route the complaint: Planning, Development, Service, Warehouse, L3,
Packaging, and Marketing.
```

<img src="./media/image37.jpeg"
style="width:6.26806in;height:3.85486in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

Scrolling down we will choose the **Generation** task (not the
classification that handles single-label classification and is limited
to 10 labels). Instead we want to be able to associate more than one
label to the input text (as seen in the example JSON above).

We will also add the training data by choosing the asset that we created
previously.

<img src="./media/image38.jpeg"
style="width:6.26806in;height:3.87569in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

<img src="./media/image39.jpeg"
style="width:6.26806in;height:3.90556in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

Now that we have loaded the data, let’s look at the training parameters
(for this lab we will keep the default values).

<img src="./media/image40.jpeg"
style="width:6.26806in;height:3.9125in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

<img src="./media/image41.jpeg"
style="width:6.26806in;height:3.87361in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

We can now start the tuning, that will run for several minutes.

<img src="./media/image42.jpeg"
style="width:6.26806in;height:3.89306in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

The tuning job will be queued and then executed. The tuning phase should
take from 5 to 10 minutes. When done we will be shown with the graph of
the training function for the 20 epochs that we had asked for.

<img src="./media/image43.jpeg"
style="width:6.26806in;height:3.88333in"
alt="A screenshot of a graph AI-generated content may be incorrect." />

# Running inference on a tuned model

Let’s go back to our project page. We can now list 3 assets:

- the training data

- the tuning experiment

- the tuned model

To be able to run inference on the tuned model we need to deploy it.
Therefore, we will create a deployment for the tuned model. Let’s click
on the model asset to bring up the deployments list.

<img src="./media/image44.jpeg"
style="width:6.26806in;height:3.86806in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

We need to create a new deployment. For this step in the exercise,
you’ll **create the deployment within the project** to continue working
with the tuned model directly in the context of your model tuning
experiment. This allows you to test and iterate on the model before
promoting it for broader use. Later in the hands-on exercise, we will be
dealing with a **deployment space**. Unlike a project, a deployment
space is a separate environment designed for production-ready assets. It
supports promoting assets from multiple projects and enables deployments
across different spaces. Using the project first gives you flexibility
for experimentation, while the deployment space helps organize and
manage finalized assets for production.

<img src="./media/image45.jpeg"
style="width:6.26806in;height:3.87292in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

Let’s fill in some information on the deployment

<img src="./media/image46.jpeg"
style="width:6.26806in;height:3.90625in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

After a while the model will be deployed and ready to accept requests.

Click on the model’s name to find info on how to call it for inferencing
or to open it in the Prompt Lab.

<img src="./media/image47.jpeg"
style="width:6.26806in;height:3.89097in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

You can now open the model in the prompt lab and try the following input
texts:

```
Where are the 2 extra sets of sheets that are supposed to come
with my order?
```

```
I see a 2-door model in your TV ad, but why is that not
available?
```

```
I could not get someone on the phone who could fix my problems! Your
so-called "SMEs" are just not helpful.
```
<img src="./media/image48.jpeg"
style="width:6.26806in;height:3.89375in"
alt="A screenshot of a computer AI-generated content may be incorrect." />

**<span class="mark">OPTIONALLY</span>** try to run inference by calling
the rest API through the provided code snippet. (refer to the previous
paragraphs and update the scripts that you implemented).

[back to navigation](./)