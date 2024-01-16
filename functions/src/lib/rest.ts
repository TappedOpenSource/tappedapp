/* eslint-disable import/no-unresolved */
import { onRequest } from "firebase-functions/v2/https";
import { opportunitiesRef, usersRef } from "./firebase";

export const getUserById = onRequest(async (req, res) => {
  const { id } = req.query;

  if (typeof id !== "string") {
    res.status(400).send("Invalid request");
    return;
  }

  const userSnap = await usersRef.doc(id).get();
  const userData = userSnap.data();

  res.send(userData);
});

export const getUserByUsername = onRequest(async (req, res) => {
  const { username } = req.query;
    
  if (typeof username !== "string") {
    res.status(400).send("Invalid request");
    return;
  }
    
  const userSnap = await usersRef.where("username", "==", username).get();
  const userData = userSnap.docs[0].data();
    
  res.send(userData);
});

export const getOpportunityById = onRequest(async (req, res) => {
  const { id } = req.query;

  if (typeof id !== "string") {
    res.status(400).send("Invalid request");
    return;
  }

  const opportunitySnap = await opportunitiesRef.doc(id).get();
  const opportunityData = opportunitySnap.data();

  res.send(opportunityData);
});
