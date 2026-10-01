import 'package:movie_ticket_mobile/features/auth/model/user.dart';

const testUser = User(
  id: 7,
  name: 'Dara Sok',
  email: 'dara@example.com',
  phone: '012345678',
  role: 'CUSTOMER',
  points: 120,
  status: UserStatus.active,
);

const profileJson = {
  'id': 7,
  'name': 'Dara Sok',
  'email': 'dara@example.com',
  'phone': '012345678',
  'role': 'CUSTOMER',
  'points': 120,
  'status': 'ACTIVE',
};

const tokenJson = {
  'message': 'Login successful for dara@example.com',
  'email': 'dara@example.com',
  'name': 'Dara Sok',
  'role': 'CUSTOMER',
  'redirectUrl': '/movies',
  'access_token': 'access-1',
  'refresh_token': 'refresh-1',
  'expires_in': 300,
  'token_type': 'Bearer',
};
