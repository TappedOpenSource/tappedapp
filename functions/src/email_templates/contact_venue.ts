import { SocialFollowing, UserModel } from "../types/models";

export const contactVenueTemplate = ({ performer, collaborators, emailText }: {
  performer: UserModel,
  collaborators: UserModel[],
  emailText: string,
}): { html: string; text: string } => {
  const username = performer.username;
  const displayName = performer.artistName || username;

  const html = `
  <p>Hey</p>

  <p>${emailText}</p> 
  
    ${formatSocialLinks(performer.socialFollowing)}

    <p>You can check my past booking history on my here <a href="https://app.tapped.ai/${username}">https://app.tapped.ai/${username}</a></p>

    ${formatPressKit(performer)}

    ${formatCollaborators(collaborators)}
  
  <p>If you require any additional information or wish to discuss this opportunity further please email me back and let me know.<p>
  
  <p>Thanks,</p>
  <p>${displayName}</p>

  <p>Sent from <a href="https://tapped.ai">Tapped Ai</a></p>
  `;

  const text = `
    Hey, 

    ${emailText}

    ${formatSocialLinksText(performer.socialFollowing)}

    Past Bookings:  You can check my past booking history on my here https://app.tapped.ai/u/${username}

    ${formatPressKitText(performer)}

    ${formatCollaboratorsText(collaborators)}

    If you require any additional information or wish to discuss this opportunity further please email me back and let me know.

    Sent from Tapped Ai

    Thanks,
    ${displayName}
  `

  return {
    text,
    html,
  };
}

const formatSocialLinks = (
  socialFollowing: SocialFollowing,
): string => {
  const { 
    instagramHandle, 
    facebookHandle, 
    twitterHandle, 
    spotifyUrl, 
    youtubeChannelId,
    soundcloudHandle,
  } = socialFollowing;
  const row = (label: string, link: string) => {
    if (!link) {
      return "";
    }
    return `<p>${label}: <a href="${link}">${link}</a></p>`;
  }

  const instagram = instagramHandle ? row("Instagram", `https://instagram.com/${instagramHandle}`) : "";
  const facebook = facebookHandle ? row("Facebook", `https://facebook.com/${facebookHandle}`) : "";
  const twitter = twitterHandle ? row("Twitter", `https://twitter.com/${twitterHandle}`) : "";
  const spotify = spotifyUrl ? row("Spotify", spotifyUrl) : "";
  const youtube = youtubeChannelId ? row("Youtube", `https://youtube.com/channel/${youtubeChannelId}`) : "";
  const soundcloud = soundcloudHandle ? row("Soundcloud", `https://soundcloud.com/${soundcloudHandle}`) : "";

  const socialLinks = `
    <div style="margin-top: 20px;">
      <h3>Social Links</h3>
      ${instagram}
      ${facebook}
      ${twitter}
      ${spotify}
      ${youtube}
      ${soundcloud}
    </div>
    `;

  return socialLinks;
}

const formatSocialLinksText = (
  socialFollowing: SocialFollowing,
): string => {
  const { 
    instagramHandle, 
    facebookHandle, 
    twitterHandle, 
    spotifyUrl, 
    youtubeChannelId,
    soundcloudHandle,
  } = socialFollowing;
  const row = (label: string, link: string) => {
    if (!link) {
      return "";
    }
    return `${label}: ${link}`;
  }

  const instagram = instagramHandle ? row("Instagram", `https://instagram.com/${instagramHandle}`) : "";
  const facebook = facebookHandle ? row("Facebook", `https://facebook.com/${facebookHandle}`) : "";
  const twitter = twitterHandle ? row("Twitter", `https://twitter.com/${twitterHandle}`) : "";
  const spotify = spotifyUrl ? row("Spotify", spotifyUrl) : "";
  const youtube = youtubeChannelId ? row("Youtube", `https://youtube.com/channel/${youtubeChannelId}`) : "";
  const soundcloud = soundcloudHandle ? row("Soundcloud", `https://soundcloud.com/${soundcloudHandle}`) : "";

  const socialLinks = `
        Social Links
        ${instagram}
        ${facebook}
        ${twitter}
        ${spotify}
        ${youtube}
        ${soundcloud}
        `;

  return socialLinks;
}

const formatPressKit = (performer: UserModel): string => {
  const pressKitUrl = performer.performerInfo?.pressKitUrl;
  if (!pressKitUrl) {
    return "";
  }
  return `
    <p><a href="${pressKitUrl}">my press kit</a></p>
  `;
}

const formatPressKitText = (performer: UserModel): string => {
  const pressKitUrl = performer.performerInfo?.pressKitUrl;
  if (!pressKitUrl) {
    return "";
  }
  return `my press kit: ${pressKitUrl}`;
}

const formatCollaborators = (collaborators: UserModel[]): string => {
  if (collaborators.length === 0) {
    return "";
  }

  const collaboratorsText = collaborators.map((collaborator) => {
    const instagramHandle = collaborator.socialFollowing?.instagramHandle;
    const spotifyUrl = collaborator.socialFollowing?.spotifyUrl;

    const href = instagramHandle ? `https://instagram.com/${instagramHandle}` : spotifyUrl;

    return `<a href=${href}>${collaborator.artistName || collaborator.username}</a>`;
  });

  const collaboratorsTextString = `<p>here are some other performers I can play with: ${collaboratorsText.join("")}</p>`

  return collaboratorsTextString;
}

const formatCollaboratorsText = (collaborators: UserModel[]): string => {
  if (collaborators.length === 0) {
    return "";
  }

  const collaboratorsText = collaborators.map((collaborator) => {
    const instagramHandle = collaborator.socialFollowing?.instagramHandle;
    const spotifyUrl = collaborator.socialFollowing?.spotifyUrl;

    const href = instagramHandle ? `https://instagram.com/${instagramHandle}` : spotifyUrl;

    return `
      ${collaborator.artistName || collaborator.username} (${href})
    `;
  });

  const collaboratorsTextString = `here are some other performers I can play with: ${collaboratorsText.join(", ")}`

  return collaboratorsTextString;
}