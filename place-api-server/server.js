const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const port = 4000;

// Use CORS middleware to allow cross-origin requests
app.use(cors());
app.use(express.json()); // To parse JSON bodies

// Google Maps API Key (replace this with your own)
const googleApiKey = 'AIzaSyBYSfMMUGh0UAI1cYJmA5zfoAyW8gCWYmU'; // Replace securely

// OpenRouteService API Key
const openRouteServiceApiKey = '5b3ce3597851110001cf62483a5657d52fa942079916e1e42b33a209'; // Replace securely

// Route to fetch place autocomplete suggestions
app.get('/places', async (req, res) => {
  try {
    const { input } = req.query; // Ensure `input` is passed as a query parameter
    if (!input) {
      return res.status(400).send({ error: 'Input query is required' });
    }

    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${input}&key=${googleApiKey}`
    );

    res.json(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error fetching place suggestions");
  }
});

// Route to get place details
app.get('/places/details', async (req, res) => {
  try {
    const { place_id } = req.query; // Ensure `place_id` is passed as a query parameter
    if (!place_id) {
      return res.status(400).send({ error: 'Place ID is required' });
    }

    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/place/details/json?place_id=${place_id}&key=${googleApiKey}`
    );

    res.json(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error fetching place details");
  }
});

// Route to calculate the route, price, and ETA
app.post('/api/route', async (req, res) => {
  try {
    const { from, to } = req.body; // Expects `from` and `to` lat-lng from the frontend

    if (!from || !to) {
      return res.status(400).send({ error: 'From and To locations are required' });
    }

    // OpenRouteService API endpoint
    const matrixApiUrl = 'https://api.openrouteservice.org/v2/matrix/driving-car';

    // Prepare the data to send in the POST body
    const postData = {
      locations: [
        [from.longitude, from.latitude], // OpenRouteService expects [lon, lat]
        [to.longitude, to.latitude]
      ]
    };

    // Send the POST request to OpenRouteService API
    const response = await axios.post(matrixApiUrl, postData, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${openRouteServiceApiKey}`  // Use Authorization header with the API Key
      }
    });

    // Extract data from the response
    const { durations, distances, routes } = response.data;
    const duration = durations[0][0] / 60; // ETA in minutes
    const distance = distances[0][0] / 1000; // Distance in km

    // Example price calculation (adjust per your logic)
    const baseFare = 40;
    const ratePerKm = 15;
    const ratePerMinute = 2;
    const price = baseFare + (distance * ratePerKm) + (duration * ratePerMinute);

    // Decode polyline for the route
    const routePoints = decodePolyline(routes[0].geometry);

    // Send the data back to the frontend
    res.json({
      eta: `ETA: ${duration.toFixed(0)} mins`,
      price: `Price: ₱${price.toFixed(2)}`,
      routePoints: routePoints
    });
  } catch (error) {
    console.error(error);
    res.status(500).send("Error fetching route data");
  }
});


// Helper function to decode polyline
function decodePolyline(encoded) {
  let polylinePoints = [];
  let index = 0;
  let len = encoded.length;
  let lat = 0;
  let lng = 0;

  while (index < len) {
    let b;
    let shift = 0;
    let result = 0;

    do {
      b = encoded.charCodeAt(index) - 63;
      index++;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    let dlat = (result & 1) !== 0 ? ~(result >> 1) : result >> 1;
    lat += dlat;

    shift = 0;
    result = 0;

    do {
      b = encoded.charCodeAt(index) - 63;
      index++;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    let dlng = (result & 1) !== 0 ? ~(result >> 1) : result >> 1;
    lng += dlng;

    polylinePoints.push({ lat: lat / 1E5, lng: lng / 1E5 });
  }

  return polylinePoints;
}

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
