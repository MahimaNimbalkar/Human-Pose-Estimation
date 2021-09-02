# Human-Pose-Estimation

The aim was to build an efficient human pose estimation model using classification techniques. It analyses the dataset which will comprises of the coordinates of different joints of the human body and predicts the correct class of the activity (human pose) picturized.

Dataset used for estimating poses of humans is MPII. This data set basically consists of
the coordinates of specific poses, activity and the category.
MPII Human Pose Dataset- 17372 images
Rows: 17373
Columns: 37
1-image (name)
2-string
34-numeric
The inputs to the model are coordinates of joints from the dataset.

After deriving the costs and accuracy of several different models, it was concluded that the Random Forest Algorithm gave a highest throughput.
We've implemented this using R Studio as part of our IBM Mini Project.
