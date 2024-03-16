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
  slackWebhookUrl
}: {
  title: string;
  body: string;
  slackWebhookUrl: string;
}): Promise<void> {
  try {
    const message = {
      text: `*${title}* - ${body}`,
    };
    const response = await fetch(slackWebhookUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(message),
    });

    if (!response.ok) {
      throw new Error(`slack notification failed to send with status ${response.status}`);
    }
  } catch (error) {
    console.error(error);
  }
}
