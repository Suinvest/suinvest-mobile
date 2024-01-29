String trimUserAddress(String address, int lengthPre, int lengthPost) {
  return ('${address.substring(0, lengthPre)}...${address.substring(address.length - lengthPost, address.length)}');
}