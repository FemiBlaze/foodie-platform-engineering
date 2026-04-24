import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
stages: [
{ duration: '2m', target: 50 },
{ duration: '3m', target: 100 },
{ duration: '3m', target: 200 },
{ duration: '3m', target: 300 },
{ duration: '3m', target: 400 },
{ duration: '3m', target: 500 },
{ duration: '3m', target: 600},
{ duration: '3m', target: 700 },
{ duration: '3m', target: 800 },
{ duration: '3m', target: 900 },
{ duration: '3m', target: 1000 },
// { duration: '3m', target: 1200 },
// { duration: '3m', target: 1400 },
// { duration: '3m', target: 1500 },
{ duration: '2m', target: 0 },
],
thresholds: {
http_req_duration: ['p(95)<2000'],
http_req_failed: ['rate<0.01'],
},
};

export default function () {
const res = http.get('http://foodie-alb-1644305675.eu-west-1.elb.amazonaws.com');

check(res, {
'status is 200': (r) => r.status === 200,
});

sleep(Math.random() * 3 + 1); // realistic user think time (1–4s)
}
