function dzdx_t = lower_tri(Q, dLdQ, R1)

dzdx_t = tril(Q'*dLdQ*R1);
