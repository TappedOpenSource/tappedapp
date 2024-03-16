import { fcm } from "./firebase";
import { getFoundersDeviceTokens } from "./utils";

export async function notifyFounders({ title, body }: {
    title: string;
    body: string;
}): Promise<void> {
  const devices = await getFoundersDeviceTokens();
  const payload = {
    notification: {
      title,
      body,
    }
  };

  fcm.sendToDevice(devices, payload);
}


export async function slackNotification({
  title,
  body,
}: {
  title: string;
  body: string;
}): Promise<void> {
  try {
    const message = {
      text: `*${title}* - ${body}`,
    };
    const response = await fetch(SLACK_WEBHOOK_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(message),
    });

    if (response.ok) {
      console.log("Notification sent to Slack successfully");
    } else {
      throw new Error("Slack notification failed to send");
    }
  } catch (error) {
    console.error(error);
  }
}
