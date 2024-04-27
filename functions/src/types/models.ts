import type { Timestamp } from "firebase-admin/firestore";
import { firestore } from "firebase-admin";

export type Option<T> = T | null | undefined;

export type OldUserModel = {
  id: string;
  email?: string;
  username?: string;
  artistName?: string;
  bio?: string;
  profilePicture?: string;
  location?: string;
  genres?: Array<string>;
  onboarded?: boolean;
  loopsCount?: number;
  badgesCount?: number;
  reviewCount?: number;
  placeId?: string;
  geohash?: string;
  lat?: number;
  lng?: number;
  deleted?: boolean;
  overallRating?: number;
  shadowBanned?: boolean;
  twitterHandle?: string;
  instagramHandle?: string;
  tiktokHandle?: string;
  soundcloudHandle?: string;
  youtubeChannelId?: string;
  pushNotificationsLikes?: boolean;
  pushNotificationsComments?: boolean;
  pushNotificationsFollows?: boolean;
  pushNotificationsDirectMessages?: boolean;
  pushNotificationsITLUpdates?: boolean;
  emailNotificationsAppReleases?: boolean;
  emailNotificationsITLUpdates?: boolean;
  stripeConnectedAccountId?: string;
  stripeCustomerId?: string;
};

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
  bookingEmail?: Option<string>;
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
  addedByUser?: boolean;
  serviceId: string;
  name: string;
  note: string;
  requesterId: string;
  requesteeId: string;
  status: string;
  rate: number;
  startTime: firestore.Timestamp;
  endTime: firestore.Timestamp;
  timestamp: firestore.Timestamp;
  location?: Location;
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
