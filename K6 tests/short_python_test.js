import http from 'k6/http';
import { sleep, check } from 'k6';


// test configuration
export let options = {
  stages: [
    { duration: '1m', target: 10 },  // ramp-up to 10 users over 1 minute
    { duration: '3m', target: 10 },  // stay at 10 users for 3 minutes
    { duration: '1m', target: 0 },   // ramp-down to 0 users over 1 minute
  ],
};

// correct URL to API Gateway endpoint
const url = 'https://gnoqjcvs5c.execute-api.ap-southeast-2.amazonaws.com/snakey-dev';

export default function () {
  let res = http.post(url, JSON.stringify({ key: 'value' }), {
    headers: { 'Content-Type': 'application/json' },
  });
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
  sleep(1);
}
