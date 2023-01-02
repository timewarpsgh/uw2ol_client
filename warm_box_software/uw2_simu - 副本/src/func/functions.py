
def are_two_pos_the_same(pos1, pos2):
    if pos1.x == pos2.x and pos1.y == pos2.y:
        return True
    else:
        return False


def is_id_in_list_range(id, li):
    if id < len(li):
        return True
    else:
        return False