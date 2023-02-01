**You need to get the server key from your Firebase project and configure Cloud Message API.**

# Create your project

- First go to [Firebase console](https://console.firebase.google.com/), sign in, then click on **Add project** if your project is not here yet.

![alt text][step_1]

- Give your project a name, and wait for Firebase to create it.
- Then, click on the Android icon, and configure your project.

![alt text][step_2]

- Give the package name setup from your project editor. You can ignore optional fields.
- You can download the **google-services.json** file here (you can get it later)
- Click **Next** twice and then **Continue to the console**

# Project settings

- On the left side, click the wheel and select **Project settings**.

![alt text][step_3]

### Get google-services.json file 🔑

- On the left side, click the wheel and select **Project settings**.
- You can download your **google-services.json** from here.

![alt text][step_4]

### Get server key 🔑

- In order to get the server key, you first need to go to the **Cloud Messaging** tab.
- Click the 3 dots on the right side of **Cloud Message API (Legacy)** (which is disabled by default), and select **Manage API in Google Cloud Console**.

![alt text][step_5]

- In the new tab, click **Enable**.
- Go back to your previous tab and refresh the page.
- In **Cloud Message** tab your should now find a server key under **Cloud Message API (Legacy)**

[step_1]: ./Assets/conf_firebase_step_1.jpg "Step 1"
[step_2]: ./Assets/conf_firebase_step_2.jpg "Step 2"
[step_3]: ./Assets/conf_firebase_step_3.jpg "Step 3"
[step_4]: ./Assets/conf_firebase_step_4.jpg "Step 4"
[step_5]: ./Assets/conf_firebase_step_5.jpg "Step 5"
