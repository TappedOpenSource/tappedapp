
export const newDirectMessage = ({ msg, senderDisplayName }: {
    msg: string;
    senderDisplayName: string;
}): string => `
<p>hey!

you have a new direct message on Tapped from ${senderDisplayName}!

"""
${msg}
"""

open up the Tapped App or visit <a href="https://app.tapped.ai/messages">https://app.tapped.ai/messages</a> to respond!

</p>

best,
Tapped Team
`
