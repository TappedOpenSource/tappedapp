
import type { Timestamp } from "firebase-admin/firestore";
import { firestore } from "firebase-admin";

export type UserModel = {
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

export type Badge = {
  id: string;
  name: string;
  creatorId: string;
  imageUrl: string;
  description: string;
};

export type Loop = {
  id: string;
  userId: string;
  title: string;
  description: string;
  audioPath: string;
  likeCount: number;
  downloads: number;
  commentCount: number;
  shareCount: number;
  imagePaths: Array<string>;
  tags: Array<string>;
  deleted: boolean;
};

export type Comment = {
  visitedUserId: string;
  rootLoopId: string;
  userId: string;
  content: string;
  parentId: string | null;
  children: Array<string>;
};

export type Booking = {
  id: string;
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
}

export type Activity = {
  // id: string;
  toUserId: string;
  // timestamp: firestore.Timestamp;
  // markedRead: boolean;
}
export type UserToUserActivity = Activity & { fromUserId: string }
export type FollowActivity = UserToUserActivity & { type: "follow", }
export type LikeActivity = UserToUserActivity & { type: "like"; loopId: string }
export type CommentActivity = UserToUserActivity & { type: "comment", rootId: string, commentId: string }
export type BookingRequestActivity = UserToUserActivity & { type: "bookingRequest", bookingId: string }
export type BookingUpdateActivity = UserToUserActivity & { type: "bookingUpdate", bookingId: string, status: BookingStatus }
export type LoopMentionActivity = UserToUserActivity & { type: "loopMention", loopId: string }
export type CommentMentionActivity = UserToUserActivity & { type: "commentMention", rootId: string, commentId: string; }
export type CommentLikeActivity = UserToUserActivity & { type: "commentLike", rootId: string, commentId: string; }
export type OpportunityInterest = UserToUserActivity & { type: "opportunityInterest", opportunityId: string; }
export type BookingReminderActivity = UserToUserActivity & { type: "bookingReminder", bookingId: string; }
export type SearchAppearanceActivity = Activity & { type: "searchAppearance", count: number; }

export type BookingStatus = "pending" | "confirmed" | "canceled"

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
}

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
