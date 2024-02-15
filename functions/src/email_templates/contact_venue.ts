import { SocialFollowing, UserModel } from "../types/models";

export const contactVenueTemplate = ({ performer, venue, note }: {
    performer: UserModel,
    note: string,
    venue: UserModel,
}): { subject: string, html: string; text: string } => {
  console.log({ performer, venue });
  const username = performer.username;
  const displayName = performer.artistName || username;
  const subject = `Performance Inquery from ${displayName}`;

  const html = `
  <p>My name is ${performer.artistName},</p> 

  <p>${note}</p>
  
    ${formatSocialLinks(performer.socialFollowing)}

    <p>You can check my past booking history on my here <a href="https://tapped.ai/${username}">https://tapped.ai/${username}</a></p>
  
  <p>If you require any additional information or wish to discuss this opportunity further please email me back and let me know.<p>
  
  <p>Sent from <a href="https://tapped.ai">Tapped Ai</a></p>
  
  <p>Thanks,</p>
  <p>${displayName}</p>
  `;

  const text = `
    My name is ${performer.artistName},

    ${note}

    ${formatSocialLinksText(performer.socialFollowing)}

    You can check my past booking history on my here https://tapped.ai/${username}

    If you require any additional information or wish to discuss this opportunity further please email me back and let me know.

    Sent from Tapped Ai

    Thanks,
    ${displayName}
  `

  return {
    subject,
    text,
    html,
  };
}

const formatSocialLinks = (socialFollowing: SocialFollowing): string => {
  const { instagramHandle, facebookHandle, twitterHandle } = socialFollowing;
  const row = (label: string, link: string) => {
    if (!link) {
      return "";
    }
    return `<a href="${link}">${label}</a>`;
  }

  const instagram = instagramHandle ? row("Instagram", `https://instagram.com/${instagramHandle}`) : "";
  const facebook = facebookHandle ? row("Facebook", `https://facebook.com/${facebookHandle}`) : "";
  const twitter = twitterHandle ? row("Twitter", `https://twitter.com/${twitterHandle}`) : "";
  //   const youtube = youtubeHandle ? row("Youtube", `https://youtube.com/${youtubeHandle}`) : "";

  const socialLinks = `
    <div style="margin-top: 20px;">
      <h3>Social Links</h3>
      ${instagram}
      ${facebook}
      ${twitter}
    </div>
    `;

  return socialLinks;
}

const formatSocialLinksText = (socialFollowing: SocialFollowing): string => {
  const { instagramHandle, facebookHandle, twitterHandle } = socialFollowing;
  const row = (label: string, link: string) => {
    if (!link) {
      return "";
    }
    return `${label}: ${link}`;
  }

  const instagram = instagramHandle ? row("Instagram", `https://instagram.com/${instagramHandle}`) : "";
  const facebook = facebookHandle ? row("Facebook", `https://facebook.com/${facebookHandle}`) : "";
  const twitter = twitterHandle ? row("Twitter", `https://twitter.com/${twitterHandle}`) : "";
  //   const youtube = youtubeHandle ? row("Youtube", `https://youtube.com/${youtubeHandle}`) : "";

  const socialLinks = `
        Social Links
        ${instagram}
        ${facebook}
        ${twitter}
        `;

  return socialLinks;
}
