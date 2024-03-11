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