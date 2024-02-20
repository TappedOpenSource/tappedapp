import { SocialFollowing, UserModel, Option } from "../types/models";

export const contactVenueTemplate = ({ performer, venue, note }: {
    performer: UserModel,
    note: string,
    venue: UserModel,
}): { subject: string, html: string; text: string } => {
  console.log({ performer, venue });
  const username = performer.username;
  const spotifyId = performer.performerInfo?.spotifyId;
  const displayName = performer.artistName || username;
  const subject = `Performance Inquery from ${displayName}`;

  const html = `
  <p>Hey</p>

  <p>My name is ${performer.artistName} and I got recommended to reach out to you by Tapped Ai.</p> 
  <p>${note}</p>
  <p>I was told to reach out to you guys to perform at a couple shows.</p>
  
    ${formatSocialLinks(performer.socialFollowing, spotifyId)}

    <div style="margin-top: 20px;">
      <h3>Past Bookings</h3>
    <p>You can check my past booking history on my here <a href="https://tapped.ai/${username}">https://tapped.ai/${username}</a></p>
    </div>
  
  <p>If you require any additional information or wish to discuss this opportunity further please email me back and let me know.<p>
  
  <p>Sent from <a href="https://tapped.ai">Tapped Ai</a></p>
  
  <p>Thanks,</p>
  <p>${displayName}</p>
  `;

  const text = `
    Hey, 

    My name is ${performer.artistName} and I got recommended to reach out to you by Tapped Ai. 
    ${note}

    ${formatSocialLinksText(performer.socialFollowing, spotifyId)}

    Past Bookings:  You can check my past booking history on my here https://tapped.ai/${username}

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

const formatSocialLinks = (
  socialFollowing: SocialFollowing, 
  spotifyId: Option<string>,
): string => {
  const { instagramHandle, facebookHandle, twitterHandle } = socialFollowing;
  const row = (label: string, link: string) => {
    if (!link) {
      return "";
    }
    return `<p>${label}: <a href="${link}">${link}</a></p>`;
  }

  const instagram = instagramHandle ? row("Instagram", `https://instagram.com/${instagramHandle}`) : "";
  const facebook = facebookHandle ? row("Facebook", `https://facebook.com/${facebookHandle}`) : "";
  const twitter = twitterHandle ? row("Twitter", `https://twitter.com/${twitterHandle}`) : "";
  const spotify = spotifyId ? row("Spotify", `https://open.spotify.com/artist/${spotifyId}`) : "";
  //   const youtube = youtubeHandle ? row("Youtube", `https://youtube.com/${youtubeHandle}`) : "";

  const socialLinks = `
    <div style="margin-top: 20px;">
      <h3>Social Links</h3>
      ${instagram}
      ${facebook}
      ${twitter}
      ${spotify}
    </div>
    `;

  return socialLinks;
}

const formatSocialLinksText = (
  socialFollowing: SocialFollowing, 
  spotifyId: Option<string>,
): string => {
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
  const spotify = spotifyId ? row("Spotify", spotifyId) : "";
  //   const youtube = youtubeHandle ? row("Youtube", `https://youtube.com/${youtubeHandle}`) : "";

  const socialLinks = `
        Social Links
        ${instagram}
        ${facebook}
        ${twitter}
        ${spotify}
        `;

  return socialLinks;
}
