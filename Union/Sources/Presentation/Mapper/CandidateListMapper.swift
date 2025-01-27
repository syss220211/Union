//
//  CandidateListMapper.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

final class CandidateListMapper {
    static func toCandidateListEntity(dto: CandidateListDTO) -> CandidateListEntity {
        return CandidateListEntity(
            totalPages: dto.totalPages ?? 0,
            totalElements: dto.totalElements ?? 0,
            size: dto.size ?? 0,
            content: (dto.content ?? []).map { toCandidateContentEntity(dto: $0) },
            number: dto.number ?? 0,
            sort: toSortEntity(dto: dto.sort),
            pageable: toPageableEntity(dto: dto.pageable),
            numberOfElements: dto.numberOfElements ?? 0,
            first: dto.first ?? false,
            last: dto.last ?? false,
            empty: dto.empty ?? false
        )
    }

    private static func toCandidateContentEntity(dto: CandidateContentDTO) -> CandidateContentEntity {
        return CandidateContentEntity(
            id: dto.id ?? 0,
            candidateNumber: dto.candidateNumber ?? 0,
            name: dto.name ?? "",
            profileUrl: dto.profileUrl ?? "",
            voteCnt: dto.voteCnt ?? ""
        )
    }

    private static func toSortEntity(dto: SortDTO?) -> SortEntity {
        guard let dto = dto else {
            return SortEntity(empty: false, sorted: false, unsorted: false)
        }
        return SortEntity(
            empty: dto.empty ?? false,
            sorted: dto.sorted ?? false,
            unsorted: dto.unsorted ?? false
        )
    }

    private static func toPageableEntity(dto: PageableDTO?) -> PageableEntity {
        guard let dto = dto else {
            return PageableEntity(
                offset: 0,
                sort: SortEntity(empty: false, sorted: false, unsorted: false),
                pageNumber: 0,
                pageSize: 0,
                paged: false,
                unpaged: false
            )
        }
        return PageableEntity(
            offset: dto.offset ?? 0,
            sort: toSortEntity(dto: dto.sort),
            pageNumber: dto.pageNumber ?? 0,
            pageSize: dto.pageSize ?? 0,
            paged: dto.paged ?? false,
            unpaged: dto.unpaged ?? false
        )
    }
}
