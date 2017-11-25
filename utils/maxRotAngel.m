function [m_r,i_r] =  maxRotAngel(r)

m_r = 0; i_r = 0;
for i = 1 : size(r,3)
    r_a = calRotAngel(r(:,:,i));
    if r_a > m_r
        m_r = r_a;
        i_r = i;
    end
end
