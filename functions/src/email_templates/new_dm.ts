
export const newDirectMessage = ({ msg, senderDisplayName }: {
    msg: string;
    senderDisplayName: string;
}): string => `
<p>
hey!
</p>

<p>
you have a new direct message on Tapped from ${senderDisplayName}!
</p>

<p>
'${msg}'
</p>

<p>open up the Tapped App or visit https://app.tapped.ai/messages to respond!</p>

<p>best,</p>
<p>Tapped Team</p>
`
