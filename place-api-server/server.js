const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const port = 4000;

// Use CORS middleware to allow cross-origin requests
app.use(cors());

// Google Maps API Key (replace this with your own)
const googleApiKey = 'AIzaSyBYSfMMUGh0UAI1cYJmA5zfoAyW8gCWYmU';

// Route to get place details
app.get('/places/details', async (req, res) => {
  try {
    const { place_id } = req.query; // Ensure `place_id` is passed as a query parameter
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/place/details/json?place_id=${place_id}&key=${googleApiKey}` // Use the correct variable name
    );
    res.json(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error fetching place details");
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
