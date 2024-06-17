import type { Timestamp } from "firebase-admin/firestore";
import { firestore } from "firebase-admin";

export type Option<T> = T | null ;

export type Location = {
  placeId: string;
  geohash: string;
  lat: number;
  lng: number;
};

export type SocialFollowing = {
  youtubeChannelId?: Option<string>;
  tiktokHandle?: Option<string>;
  tiktokFollowers: number;
  instagramHandle?: Option<string>;
  instagramFollowers: number;
  twitterHandle?: Option<string>;
  twitterFollowers: number;
  facebookHandle?: Option<string>;
  facebookFollowers: number;
  spotifyUrl?: Option<string>;
  soundcloudHandle?: Option<string>;
  soundcloudFollowers: number;
  audiusHandle?: Option<string>;
  audiusFollowers: number;
  twitchHandle?: Option<string>;
  twitchFollowers: number;
};

export type BookerInfo = {
  rating?: Option<number>;
  reviewCount: number;
};

export type PerformerInfo = {
  pressKitUrl?: Option<string>;
  genres: string[];
  rating?: Option<number>;
  reviewCount: number;
  label: string;
  spotifyId?: Option<string>;
};

export type VenueInfo = {
  genres?: Option<string[]>;
  bookingEmail?: Option<string>;
  websiteUrl?: Option<string>;
  autoReply?: Option<string>;
  capacity?: Option<number>;
  idealArtistProfile?: Option<string>;
  productionInfo?: Option<string>;
  frontOfHouse?: Option<string>;
  monitors?: Option<string>;
  microphones?: Option<string>;
  lights?: Option<string>;
};

export type EmailNotifications = {
  appReleases: boolean;
  tappedUpdates: boolean;
  bookingRequests: boolean;
};

export type PushNotifications = {
  appReleases: boolean;
  tappedUpdates: boolean;
  bookingRequests: boolean;
  directMessages: boolean;
};

export type UserModel = {
  id: string;
  email: string;
  unclaimed: boolean;
  timestamp: Timestamp;
  username: string;
  artistName: string;
  bio: string;
  occupations: string[];
  profilePicture?: Option<string>;
  location?: Option<Location>;
  badgesCount: number;
  performerInfo?: Option<PerformerInfo>;
  venueInfo?: Option<VenueInfo>;
  bookerInfo?: Option<BookerInfo>;
  emailNotifications: EmailNotifications;
  pushNotifications: PushNotifications;
  deleted: boolean;
  socialFollowing: SocialFollowing;
  stripeConnectedAccountId?: Option<string>;
  stripeCustomerId?: Option<string>;
};

export type Badge = {
  id: string;
  name: string;
  creatorId: string;
  imageUrl: string;
  description: string;
};

export type Booking = {
  id: string;
  calendarEventId?: string;
  serviceId: string | null;
  addedByUser: boolean;
  name: string;
  note: string;
  requesterId: Option<string>;
  requesteeId: string;
  status: "pending" | "confirmed" | "cancelled";
  genres: string[];
  rate: number;
  startTime: Timestamp;
  endTime: Timestamp;
  timestamp: Timestamp;
  location?: Option<Location>;
  flierUrl?: Option<string>;
  eventUrl?: Option<string>;
  crawlerInfo?: {
    runId: string;
    timestamp: Timestamp;
    encodedLink: string;
  };
  scraperInfo?: {
    scraperId: string;
    runId: string;
  };
  referenceEventId: Option<string>;
};

export type Activity = {
  // id: string;
  toUserId: string;
  // timestamp: firestore.Timestamp;
  // markedRead: boolean;
};
export type UserToUserActivity = Activity & { fromUserId: string };
export type FollowActivity = UserToUserActivity & { type: "follow" };
export type LikeActivity = UserToUserActivity & {
  type: "like";
  loopId: string;
};
export type CommentActivity = UserToUserActivity & {
  type: "comment";
  rootId: string;
  commentId: string;
};
export type BookingRequestActivity = UserToUserActivity & {
  type: "bookingRequest";
  bookingId: string;
};
export type BookingUpdateActivity = UserToUserActivity & {
  type: "bookingUpdate";
  bookingId: string;
  status: BookingStatus;
};
export type LoopMentionActivity = UserToUserActivity & {
  type: "loopMention";
  loopId: string;
};
export type CommentMentionActivity = UserToUserActivity & {
  type: "commentMention";
  rootId: string;
  commentId: string;
};
export type CommentLikeActivity = UserToUserActivity & {
  type: "commentLike";
  rootId: string;
  commentId: string;
};
export type OpportunityInterest = UserToUserActivity & {
  type: "opportunityInterest";
  opportunityId: string;
};
export type BookingReminderActivity = UserToUserActivity & {
  type: "bookingReminder";
  bookingId: string;
};
export type SearchAppearanceActivity = Activity & {
  type: "searchAppearance";
  count: number;
};

export type BookingStatus = "pending" | "confirmed" | "canceled";

export type BookerReview = {
  id: string;
  bookingId: string;
  performerId: string;
  bookerId: string;
  timestamp: firestore.Timestamp;
  overallRating: number;
  overallReview: string;
  type: "booker";
};

export type PerformerReview = {
  id: string;
  bookingId: string;
  performerId: string;
  bookerId: string;
  timestamp: firestore.Timestamp;
  overallRating: number;
  overallReview: string;
  type: "performer";
};

export type MarketingPlan = {
  id: string;
  userId: string;
  name: string;
  type: "single";
  content: string;
  prompt: string;
  timestamp: Timestamp;
};

export type GuestMarketingPlan = {
  prompt?: string;
  content?: string;
  checkoutSessionId?: string;
  clientReferenceId: string;
  status: "initial" | "processing" | "completed" | "failed";
};

export type MarketingForm = {
  id: string;
  artistName: string;
  // genre: string;
  productName: string;
  socialFollowing: string;
  marketingType: "single" | "ep" | "album";
  moreToCome: string;
  aesthetic: string;
  budget: string;
  timeline: string;
  audience: string;
  timestamp: Date;
};

export type Opportunity = {
  id: string;
  userId: string;
  title: string;
  description: string;
  placeId: string;
  geohash: string;
  lat: number;
  lng: number;
  timestamp: Date;
  startTime: Date;
  endTime: Date;
  isPaid: boolean;
  touched: "like" | "dislike" | null;
};

export type OpportunityFeedItem = Opportunity & {
  userComment?: string | null;
};

export type VenueContactRequest = {
  venue: UserModel;
  user: UserModel;
  bookingEmail: string;
  attachments: string[];
  note: string;
  timestamp: Timestamp;
  originalMessageId: Option<string>;
  latestMessageId: Option<string>;
  subject: Option<string>;
  allEmails: string[];
  collaborators: string[];
};

export type EventData = {
  crawlerInfo: {
    runId: string;
    timestamp: Timestamp;
  };
  eventId: string;
  venue: UserModel;
  isMusicEvent: boolean;
  url: Option<string>;
  title: Option<string>;
  description: Option<string>;
  performers: string[];
  ticketPrice: Option<number>;
  doorPrice: Option<number>;
  startTime: Timestamp;
  endTime: Timestamp;
  flierUrl: Option<string>;
};
