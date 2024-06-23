
export function createEmailMessageId(): string {
  const currentTime = Date.now().toString(36);
  const randomPart = Math.floor(
    Math.random() * Number.MAX_SAFE_INTEGER
  ).toString(36);
  const messageId = `<${currentTime}.${randomPart}@tapped.ai>`;

  return messageId;
}

